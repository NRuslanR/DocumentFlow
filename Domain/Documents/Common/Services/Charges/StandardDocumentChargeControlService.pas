unit StandardDocumentChargeControlService;

interface

uses

  DocumentChargeControlService,
  Employee,
  IDocumentUnit,
  Document,
  DocumentCharges,
  DocumentChargeInterface,
  DocumentChargeAccessRights,
  DocumentChargeKindsControlService,
  DocumentChargeAccessRightsService,
  DocumentChargeCreatingService,
  DocumentChargeKind,
  VariantListUnit,
  SysUtils;

type

  TStandardDocumentChargeControlService =
    class (TInterfacedObject, IDocumentChargeControlService)

      protected

        FChargeKindsControlService: IDocumentChargeKindsControlService;
        
      public

        constructor Create(
          ChargeKindsControlService: IDocumentChargeKindsControlService
        );

        procedure CreateDocumentCharges(
          const ChargeKindId: Variant;
          const Assigning: TEmployee;
          const Document: IDocument;
          const Performers: TEmployees;
          var DocumentCharges: IDocumentCharges;
          var AccessRightsList: TDocumentChargeAccessRightsList
        );

        procedure GetDocumentCharge(
          const ChargeId: Variant;
          const Document: IDocument;
          const Employee: TEmployee;
          var DocumentCharge: IDocumentCharge;
          var AccessRights: TDocumentChargeAccessRights
        );

        procedure EnsureEmployeeMayRemoveDocumentCharges(
          const Employee: TEmployee;
          const ChargeIds: TVariantList;
          const Document: IDocument
        );

    end;

  
implementation

uses

  DocumentChargeServiceRegistry,
  DocumentChargeListChangingRule,
  IDomainObjectBaseUnit;
  
{ TStandardDocumentChargeControlService }

constructor TStandardDocumentChargeControlService.Create(
  ChargeKindsControlService: IDocumentChargeKindsControlService
);
begin

  inherited Create;

  FChargeKindsControlService := ChargeKindsControlService;

end;

procedure TStandardDocumentChargeControlService.CreateDocumentCharges(
  const ChargeKindId: Variant;
  const Assigning: TEmployee;
  const Document: IDocument;
  const Performers: TEmployees;
  var DocumentCharges: IDocumentCharges;
  var AccessRightsList: TDocumentChargeAccessRightsList
);
var
    ChargeKind: TDocumentChargeKind;
    FreeChargeKind: IDomainObjectBase;
    
    Charge: IDocumentCharge;

    AccessRights: TDocumentChargeAccessRights;
    FreeAccessRights: IDomainObjectBase;

    ChargeCreatingService: IDocumentChargeCreatingService;
    ChargeAccessRightsService: IDocumentChargeAccessRightsService;
begin

  ChargeKind := FChargeKindsControlService.FindDocumentChargeKindById(ChargeKindId);

  if not Assigned(ChargeKind) then begin

    raise TDocumentChargeControlServiceException.Create(
      'ѕри попытке создани€ поручени€ не найден требуемый тип'
    );
    
  end;

  FreeChargeKind := ChargeKind;

  ChargeCreatingService :=
    TDocumentChargeServiceRegistry
      .Instance
        .GetDocumentChargeCreatingService(ChargeKind.ChargeClass);

  DocumentCharges :=
    ChargeCreatingService.CreateDocumentCharges(ChargeKindId, Document, Performers);

  AccessRightsList := TDocumentChargeAccessRightsList.Create;

  ChargeAccessRightsService :=
    TDocumentChargeServiceRegistry
      .Instance
        .GetDocumentChargeAccessRightsService(ChargeKind.ChargeClass);
        
  try

    for Charge in DocumentCharges do begin

      AccessRights :=
        ChargeAccessRightsService
          .EnsureEmployeeHasDocumentChargeAccessRights(
            Assigning, Charge, Document
          );

      FreeAccessRights := AccessRights;

      AccessRightsList.Add(AccessRights);
      
    end;

  except

    FreeAndNil(AccessRightsList);

    Raise;
    
  end;
  
end;

procedure TStandardDocumentChargeControlService.EnsureEmployeeMayRemoveDocumentCharges(
  const Employee: TEmployee;
  const ChargeIds: TVariantList;
  const Document: IDocument
);
var
    Charge: IDocumentCharge;
    Charges: IDocumentCharges;

    ChargeObj: TDocumentCharge;

    FailedCharges: IDocumentCharges;
    ExceptionMsg: String;
begin

  Charges := Document.Charges.FindByIdentities(ChargeIds);

  if Charges.Count <> ChargeIds.Count then begin

    raise TDocumentChargeKindsControlServiceException.Create(
      'Ќекоторые из затребованных на удаление поручений ' +
      'не найдены'
    );
    
  end;

  FailedCharges := TDocumentCharges.Create;
  
  for Charge in Charges do begin

    try

      TDocument(Document.Self)
        .WorkingRules
          .ChargeListChangingRule
            .EnsureEmployeeMayRemoveDocumentCharge(
              Employee, Document, Charge
            );

    except

      on E: TDocumentChargeListChangingRuleException do begin

        FailedCharges.AddCharge(Charge);

        ExceptionMsg := ExceptionMsg + sLineBreak + E.Message;

      end;

    end;

  end;

  if not FailedCharges.IsEmpty then begin

    raise TFailedRemovingDocumentChargesEnsuringException.Create(
      FailedCharges,
      'Ќевозможно удалить требуемые поручени€, поскольку:' + ExceptionMsg
    );

  end;

end;

procedure TStandardDocumentChargeControlService.GetDocumentCharge(
  const ChargeId: Variant;
  const Document: IDocument;
  const Employee: TEmployee;
  var DocumentCharge: IDocumentCharge;
  var AccessRights: TDocumentChargeAccessRights
);
var
    ChargeAccessRightsService: IDocumentChargeAccessRightsService;
begin

  DocumentCharge := Document.Charges.FindByIdentity(ChargeId);

  if not Assigned(DocumentCharge) then begin

    raise TDocumentChargeNotFoundException.Create(
      'ѕоручение не найдено'
    );
    
    Exit;

  end;

  ChargeAccessRightsService :=
    TDocumentChargeServiceRegistry
      .Instance
        .GetDocumentChargeAccessRightsService(TDocumentCharge(DocumentCharge.Self).ClassType);

  AccessRights :=
    ChargeAccessRightsService
      .EnsureEmployeeHasDocumentChargeAccessRights(
        Employee, DocumentCharge, Document
      );

end;

end.
