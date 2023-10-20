unit StandardDocumentChargeSheetCreatingService;

interface

uses

  DocumentChargeCreatingService,
  DocumentChargeSheetCreatingService,
  SysUtils,
  DocumentChargeInterface,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetAccessRights,
  DocumentChargeSheetAccessRightsService,
  DocumentChargeSheet,
  IDocumentUnit,
  DocumentCharges,
  Employee,
  Document,
  IDomainObjectBaseListUnit,
  DocumentSigningSpecification,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  GeneralDocumentChargeSheetAccessRightsService,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  EmployeeChargeIssuingRule,
  DocumentChargesSpecification,
  Classes;

type

  TStandardDocumentChargeSheetCreatingService =
    class (TInterfacedObject, IDocumentChargeSheetCreatingService)

      protected

        FGeneralDocumentChargeSheetAccessRightsService: IGeneralDocumentChargeSheetAccessRightsService;
        
        FDocumentChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;
        
        FDocumentChargeCreatingService: IDocumentChargeCreatingService;
        
        FEmployeeChargeIssuingRule: IEmployeeChargeIssuingRule;

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

      protected

        function GetDocumentChargeSheetClass(Charge: TDocumentCharge): TDocumentChargeSheetClass;

        procedure CreateDocumentChargeSheet(
          const ChargeKindId: Variant;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          const IssuingDateTime: TDateTime;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          TopLevelChargeSheet: IDocumentChargeSheet = nil
        );

        procedure InternalCreateDocumentChargeSheet(
          Charge: IDocumentCharge;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          const IssuingDateTime: TDateTime;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          TopLevelChargeSheet: IDocumentChargeSheet = nil
        ); virtual;

      protected

        procedure RaiseHeadChargeSheetCreatingExceptionIfIssuerIsNotOneOfDocumentSigners(
          Document: IDocument;
          Performer: TEmployee;
          Issuer: TEmployee
        );

        procedure RaiseIssuerIsNotOneOfDocumentSignersException(
          Document: IDocument;
          Issuer: TEmployee
        ); virtual;

      protected

        procedure RaiseExceptionIfIssuerIsNotPerformerOfChargeSheet(
          Issuer: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        );

        procedure RaiseIssuerIsNotPerformerOfChargeSheetException(
          Issuer: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        ); virtual;

      protected

        procedure RaiseExceptionIfEmployeeIsNotAllowedIssueChargeToOtherEmployee(
          Issuer, Performer: TEmployee;
          Document: IDocument
        );

      public

        constructor Create(

          GeneralDocumentChargeSheetAccessRightsService:
            IGeneralDocumentChargeSheetAccessRightsService;
            
          DocumentChargeSheetAccessRightsService:
            IDocumentChargeSheetAccessRightsService;
            
          DocumentChargeCreatingService: IDocumentChargeCreatingService;
          
          EmployeeChargeIssuingRule: IEmployeeChargeIssuingRule;

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification
          
        );

        procedure CreateHeadDocumentChargeSheet(
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; virtual;

        procedure CreateSubordinateDocumentChargeSheet(
          TopLevelChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; virtual;

        procedure CreateHeadDocumentChargeSheet(
          const ChargeKindId: Variant;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; virtual;

        procedure CreateSubordinateDocumentChargeSheet(
          const ChargeKindId: Variant;
          TopLevelChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; virtual;

    end;
    
implementation

uses

  Variants,
  IDomainObjectBaseUnit,
  VariantFunctions,
  DocumentPerforming,
  DocumentAcquaitance,
  DocumentPerformingSheet,
  DocumentAcquaitanceSheet,
  DocumentChargeSheetRuleRegistry;

{ TStandardDocumentChargeSheetCreatingService }

constructor TStandardDocumentChargeSheetCreatingService.Create(
  GeneralDocumentChargeSheetAccessRightsService: IGeneralDocumentChargeSheetAccessRightsService;
  DocumentChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;
  DocumentChargeCreatingService: IDocumentChargeCreatingService;
  EmployeeChargeIssuingRule: IEmployeeChargeIssuingRule;
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification
);
begin

  inherited Create;

  FGeneralDocumentChargeSheetAccessRightsService := GeneralDocumentChargeSheetAccessRightsService;
  FDocumentChargeSheetAccessRightsService := DocumentChargeSheetAccessRightsService;
  FDocumentChargeCreatingService := DocumentChargeCreatingService;
  FEmployeeChargeIssuingRule := EmployeeChargeIssuingRule;
  FEmployeeIsSameAsOrReplacingForOthersSpecification := EmployeeIsSameAsOrReplacingForOthersSpecification;

end;

procedure TStandardDocumentChargeSheetCreatingService.CreateHeadDocumentChargeSheet(
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  CreateHeadDocumentChargeSheet(
    Null, Document, Issuer, Performer, ChargeSheet, AccessRights, IssuingDateTime
  );

end;

procedure TStandardDocumentChargeSheetCreatingService.CreateHeadDocumentChargeSheet(
  const ChargeKindId: Variant;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  { refactor: перенести в службу прав доступа }

  RaiseHeadChargeSheetCreatingExceptionIfIssuerIsNotOneOfDocumentSigners(
    Document, Performer, Issuer
  );

  CreateDocumentChargeSheet(
    ChargeKindId,
    Document,
    Issuer,
    Performer,
    IssuingDateTime,
    ChargeSheet,
    AccessRights
  );

end;

procedure TStandardDocumentChargeSheetCreatingService.
RaiseHeadChargeSheetCreatingExceptionIfIssuerIsNotOneOfDocumentSigners(
  Document: IDocument;
  Performer, Issuer: TEmployee
);
begin

  if
    not
      TDocument(Document.Self)
        .Specifications
          .DocumentSigningSpecification
            .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
              Issuer, Document
            )
  then begin
  
    RaiseIssuerIsNotOneOfDocumentSignersException(Document, Issuer);

  end;

end;

procedure TStandardDocumentChargeSheetCreatingService.RaiseIssuerIsNotOneOfDocumentSignersException(
  Document: IDocument;
  Issuer: TEmployee
);
begin

  Raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
    '—отрудник "%s" не €вл€етс€ ' +
    'подписантом документа',
    [
      Issuer.FullName
    ]
  );

end;

procedure TStandardDocumentChargeSheetCreatingService.CreateSubordinateDocumentChargeSheet(
  TopLevelChargeSheet: IDocumentChargeSheet;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  CreateSubordinateDocumentChargeSheet(
    Null,
    TopLevelChargeSheet,
    Document,
    Issuer,
    Performer,
    ChargeSheet,
    AccessRights,
    IssuingDateTime
  );
    
end;

procedure TStandardDocumentChargeSheetCreatingService.CreateSubordinateDocumentChargeSheet(
  const ChargeKindId: Variant;
  TopLevelChargeSheet: IDocumentChargeSheet;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  RaiseExceptionIfIssuerIsNotPerformerOfChargeSheet(
    Issuer, TopLevelChargeSheet
  );

  RaiseExceptionIfEmployeeIsNotAllowedIssueChargeToOtherEmployee(
    Issuer, Performer, Document
  );

  CreateDocumentChargeSheet(
    ChargeKindId,
    Document,
    Issuer,
    Performer,
    IssuingDateTime,
    ChargeSheet,
    AccessRights,
    TopLevelChargeSheet
  );

end;

procedure TStandardDocumentChargeSheetCreatingService.
  RaiseExceptionIfIssuerIsNotPerformerOfChargeSheet(
    Issuer: TEmployee;
    ChargeSheet: IDocumentChargeSheet
  );
begin

  if
     not
     FEmployeeIsSameAsOrReplacingForOthersSpecification
      .IsEmployeeSameAsOrReplacingForOtherEmployeeOrViceVersa(
        Issuer, ChargeSheet.Performer
      )

  then begin

    RaiseIssuerIsNotPerformerOfChargeSheetException(Issuer, ChargeSheet);

  end;

end;

procedure TStandardDocumentChargeSheetCreatingService.RaiseIssuerIsNotPerformerOfChargeSheetException(
  Issuer: TEmployee; ChargeSheet: IDocumentChargeSheet);
begin

  Raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
    '—отрудник "%s" не €вл€етс€ ' +
    'исполн€ющим об€занности дл€' +
    'сотрудника "%s"',
    [
      Issuer.FullName,
      ChargeSheet.Performer.FullName
    ]
  );

end;

procedure TStandardDocumentChargeSheetCreatingService
  .RaiseExceptionIfEmployeeIsNotAllowedIssueChargeToOtherEmployee(
    Issuer, Performer: TEmployee; Document: IDocument
  );
begin

  FEmployeeChargeIssuingRule.
    EnsureThatEmployeeMayIssueChargeToOtherEmployee(
      Issuer, Performer
    );

end;

function TStandardDocumentChargeSheetCreatingService.GetDocumentChargeSheetClass(
  Charge: TDocumentCharge): TDocumentChargeSheetClass;
begin

  Result := TDocumentChargeSheetClass(Charge.ChargeSheetType);
  
end;

procedure TStandardDocumentChargeSheetCreatingService.CreateDocumentChargeSheet(
  const ChargeKindId: Variant;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  const IssuingDateTime: TDateTime;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  TopLevelChargeSheet: IDocumentChargeSheet
);
var
    ChargeRef: IDocumentCharge;
    GeneralDocumentChargeSheetAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
    FreeAccessRights: IDomainObjectBase;
begin

  {
    refactor: провер€ть количество листов поручений дл€ Performer, чтобы не создавать
    более одного поручени€ на исполнител€. Ќа данный момент разрешено
    не более одного поручени€
  }

  GeneralDocumentChargeSheetAccessRights :=
    FGeneralDocumentChargeSheetAccessRightsService
      .EnsureEmployeeHasDocumentChargeSheetsAccessRights(
        TDocument(Document.Self), Issuer
      );

  FreeAccessRights := GeneralDocumentChargeSheetAccessRights;
                            
  if not GeneralDocumentChargeSheetAccessRights.AnyChargeSheetsCanBeIssued
  then begin

    Raise TDocumentChargeSheetCreatingServiceException.Create(
      'ќтсутствуют права дл€ выдачи поручений'
    );
    
  end;
   
  ChargeRef := Document.FindChargeByPerformerOrActuallyPerformedEmployee(Performer);

  if not Assigned(ChargeRef) and VarIsNull(ChargeKindId) then begin

    Raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
      'Ќе найдено поручение дл€ исполнител€ "%s" или не был указан тип ' +
      'поручени€ дл€ создани€ соответствующего листа',
      [
        Performer.FullName
      ]
    );

  end;

  if not Assigned(ChargeRef) then begin

    ChargeRef :=
      FDocumentChargeCreatingService
        .CreateDocumentCharge(ChargeKindId, Document, Performer);

  end;

  if
    not VarIfThen(
      not Assigned(TopLevelChargeSheet),

      GeneralDocumentChargeSheetAccessRights
        .IssuingAccessRights
          .IssuingAlloweableHeadChargeSheetKinds
            .ContainsByIdentity(ChargeRef.KindId),

      GeneralDocumentChargeSheetAccessRights
          .IssuingAccessRights
            .IssuingAlloweableSubordinateChargeSheetKinds
              .ContainsByIdentity(ChargeRef.KindId)
    )
  then begin

    Raise TDocumentChargeSheetCreatingServiceException.Create(
      'ќтсутствуют права на выдачу поручений требуемого типа'
    );
    
  end;

  InternalCreateDocumentChargeSheet(
    ChargeRef, Document,
    Issuer, Performer, IssuingDateTime,
    ChargeSheet, AccessRights,
    TopLevelChargeSheet
  );

  AccessRights :=
    FDocumentChargeSheetAccessRightsService
      .EnsureEmployeeHasDocumentChargeSheetAccessRights(
        Issuer, ChargeSheet
      );
    
end;

procedure TStandardDocumentChargeSheetCreatingService.InternalCreateDocumentChargeSheet(
  Charge: IDocumentCharge;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  const IssuingDateTime: TDateTime;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  TopLevelChargeSheet: IDocumentChargeSheet
);
var
    ChargeObj: TDocumentCharge;
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeObj := TDocumentCharge(Charge.Self);

  ChargeSheet :=
    GetDocumentChargeSheetClass(ChargeObj).Create(
      ChargeObj,
      Issuer,
      VarIfThen(IssuingDateTime = 0, Now, IssuingDateTime),
      TDocumentChargeSheetRuleRegistry
        .Instance
          .GetDocumentChargeSheetWorkingRules(
            TDocumentChargeSheetClass(ChargeObj.ChargeSheetType)
          )
    );

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj.InvariantsComplianceRequested := False;

  ChargeSheetObj.DocumentKindId := Document.KindIdentity;

  if Assigned(TopLevelChargeSheet) then
    ChargeSheetObj.TopLevelChargeSheetId := TopLevelChargeSheet.Identity;

  ChargeSheetObj.InvariantsComplianceRequested := True;

end;

end.
