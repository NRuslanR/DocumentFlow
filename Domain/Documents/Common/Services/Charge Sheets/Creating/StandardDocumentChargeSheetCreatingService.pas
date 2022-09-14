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
  EmployeeChargeIssuingRule,
  DocumentChargesSpecification,
  Classes;

type

  TStandardDocumentChargeSheetCreatingService =
    class (TInterfacedObject, IDocumentChargeSheetCreatingService)

      protected

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
  VariantFunctions,
  DocumentPerforming,
  DocumentAcquaitance,
  DocumentPerformingSheet,
  DocumentAcquaitanceSheet,
  DocumentChargeSheetChangingEnsurer,
  DocumentChargeSheetPerformingEnsurer,
  DocumentChargeSheetRuleRegistry;

{ TStandardDocumentChargeSheetCreatingService }

constructor TStandardDocumentChargeSheetCreatingService.Create(
  DocumentChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;
  DocumentChargeCreatingService: IDocumentChargeCreatingService;
  EmployeeChargeIssuingRule: IEmployeeChargeIssuingRule;
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification
);
begin

  inherited Create;

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
            .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(Issuer, Document)
  then
    RaiseIssuerIsNotOneOfDocumentSignersException(Document, Issuer);

end;

procedure TStandardDocumentChargeSheetCreatingService.RaiseIssuerIsNotOneOfDocumentSignersException(
  Document: IDocument;
  Issuer: TEmployee
);
begin

  Raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
    'Сотрудник "%s" не является ' +
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
    'Сотрудник "%s" не является ' +
    'исполняющим обязанности для' +
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
    Charge: TDocumentCharge;
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeRef := Document.FindChargeByPerformerOrActuallyPerformedEmployee(Performer);

  if not Assigned(ChargeRef) and VarIsNull(ChargeKindId) then begin

    Raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
      'Не найдено поручение для исполнителя "%s" или не был указан тип ' +
      'поручения для создания соответствующего листа',
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

  Charge := ChargeRef.Self as TDocumentCharge;

  ChargeSheet :=
    GetDocumentChargeSheetClass(Charge).Create(
      Charge,
      Issuer,
      VarIfThen(IssuingDateTime = 0, Now, IssuingDateTime),
      TDocumentChargeSheetRuleRegistry
        .Instance
          .GetDocumentChargeSheetWorkingRules(
            TDocumentChargeSheetClass(Charge.ChargeSheetType)
          )
    );

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
  
  ChargeSheetObj.InvariantsComplianceRequested := False;

  ChargeSheetObj.DocumentKindId := Document.KindIdentity;

  if Assigned(TopLevelChargeSheet) then
    ChargeSheetObj.TopLevelChargeSheetId := TopLevelChargeSheet.Identity;

  ChargeSheetObj.InvariantsComplianceRequested := True;
  
  ChargeSheetObj.ChangingEnsurer :=
    TDocumentChargeSheetChangingEnsurer.Create(Document);

  ChargeSheetObj.PerformingEnsurer :=
    TDocumentChargeSheetPerformingEnsurer.Create(Document);
    
  AccessRights :=
    FDocumentChargeSheetAccessRightsService
      .EnsureEmployeeHasDocumentChargeSheetAccessRights(
        Issuer, ChargeSheetObj, Document
      );
    
end;

end.
