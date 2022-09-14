unit StandardDocumentPerformingSheetCreatingService;

interface

uses

  StandardDocumentChargeSheetCreatingService,
  DocumentChargeSheetCreatingService,
  DocumentChargeInterface,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  IDocumentUnit,
  DocumentCharges,
  Employee,
  DocumentChargeSheetAccessRights,
  DepartmentEmployeeDistributionSpecification,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  EmployeeChargeIssuingRule,
  SysUtils;

type

  TStandardDocumentPerformingSheetCreatingService =
    class (TStandardDocumentChargeSheetCreatingService)

      protected

        procedure RaiseHeadChargeSheetCreatingExceptionIfNecessary(
          Document: IDocument;
          Performer: TEmployee;
          Issuer: TEmployee
        );

        procedure RaiseChargeSheetCreatingExceptionIfNecessary(
          Document: IDocument;
          Performer: TEmployee;
          Issuer: TEmployee
        );

        procedure RaiseExceptionIfDocumentAlreadyPerformed(Document: IDocument);

        procedure RaiseExceptionIfPerformerIsOneOfDocumentSigners(
          Document: IDocument;
          Performer: TEmployee;
          Issuer: TEmployee
        );

      protected

        procedure RaiseHeadChargeSheetCreatingExceptionIfPerformerIsNotOneOfDocumentPerformers(
          Document: IDocument;
          Performer: TEmployee;
          Issuer: TEmployee
        );


        procedure RaisePerformerIsNotOneOfDocumentPerformersException(
          Document: IDocument;
          Performer: TEmployee
        );

      public

        procedure CreateHeadDocumentChargeSheet(
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; override;

        procedure CreateSubordinateDocumentChargeSheet(
          TopLevelChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; override;

        procedure CreateHeadDocumentChargeSheet(
          const ChargeKindId: Variant;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; override;

        procedure CreateSubordinateDocumentChargeSheet(
          const ChargeKindId: Variant;
          TopLevelChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Issuer, Performer: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const IssuingDateTime: TDateTime = 0
        ); overload; override;
        
    end;

implementation

uses

  Document;

{ TStandardDocumentPerformingSheetCreatingService }

procedure TStandardDocumentPerformingSheetCreatingService.CreateHeadDocumentChargeSheet(
  const ChargeKindId: Variant;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  RaiseHeadChargeSheetCreatingExceptionIfNecessary(Document, Performer, Issuer);

  inherited CreateHeadDocumentChargeSheet(
    ChargeKindId, Document, Issuer, Performer, ChargeSheet, AccessRights
  );

end;

procedure TStandardDocumentPerformingSheetCreatingService.CreateHeadDocumentChargeSheet(
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  RaiseHeadChargeSheetCreatingExceptionIfNecessary(Document, Performer, Issuer);
  
  inherited CreateHeadDocumentChargeSheet(
    Document, Issuer, Performer, ChargeSheet, AccessRights, IssuingDateTime
  );

end;

procedure TStandardDocumentPerformingSheetCreatingService.CreateSubordinateDocumentChargeSheet(
  const ChargeKindId: Variant;
  TopLevelChargeSheet: IDocumentChargeSheet;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  RaiseChargeSheetCreatingExceptionIfNecessary(Document, Performer, Issuer);
  
  inherited CreateSubordinateDocumentChargeSheet(
    ChargeKindId, TopLevelChargeSheet, Document,
    Issuer, Performer, ChargeSheet, AccessRights, IssuingDateTime
  );

end;

procedure TStandardDocumentPerformingSheetCreatingService.CreateSubordinateDocumentChargeSheet(
  TopLevelChargeSheet: IDocumentChargeSheet;
  Document: IDocument;
  Issuer, Performer: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights;
  const IssuingDateTime: TDateTime
);
begin

  RaiseChargeSheetCreatingExceptionIfNecessary(Document, Performer, Issuer);
  
  inherited CreateSubordinateDocumentChargeSheet(
    TopLevelChargeSheet,
    Document,
    Issuer,
    Performer,
    ChargeSheet,
    AccessRights,
    IssuingDateTime
  );

end;

procedure TStandardDocumentPerformingSheetCreatingService.RaiseHeadChargeSheetCreatingExceptionIfNecessary(
  Document: IDocument; Performer, Issuer: TEmployee);
begin

  RaiseChargeSheetCreatingExceptionIfNecessary(Document, Performer, Issuer);
  RaiseHeadChargeSheetCreatingExceptionIfPerformerIsNotOneOfDocumentPerformers(
    Document, Performer, Issuer
  );
  
end;

procedure TStandardDocumentPerformingSheetCreatingService.
  RaiseHeadChargeSheetCreatingExceptionIfPerformerIsNotOneOfDocumentPerformers(
    Document: IDocument;
    Performer: TEmployee;
    Issuer: TEmployee
  );

begin

  if
    not
    TDocument(Document.Self)
      .Specifications
        .DocumentChargesSpecification.IsDocumentChargeAssignedForEmployee(
          Performer, Document
        )
  then
    RaisePerformerIsNotOneOfDocumentPerformersException(Document, Performer);

end;

procedure TStandardDocumentPerformingSheetCreatingService.RaisePerformerIsNotOneOfDocumentPerformersException(
  Document: IDocument; Performer: TEmployee);
begin

  raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
    'Сотрудник "%s" не является исполнителем ' +
    'данного документа',
    [
      Performer.FullName
    ]
  );

end;

procedure TStandardDocumentPerformingSheetCreatingService.RaiseChargeSheetCreatingExceptionIfNecessary(
  Document: IDocument;
  Performer, Issuer: TEmployee
);
begin

  RaiseExceptionIfDocumentAlreadyPerformed(Document);
  RaiseExceptionIfPerformerIsOneOfDocumentSigners(Document, Performer, Issuer);

end;

procedure TStandardDocumentPerformingSheetCreatingService.
  RaiseExceptionIfDocumentAlreadyPerformed(
    Document: IDocument
  );
begin

  if Document.IsPerformed then begin

    raise TDocumentChargeSheetCreatingServiceException.Create(
            'Нельзя выдавать поручение по ' +
            'документу, так как он уже ' +
            'исполнен'
          );

  end;

end;

procedure TStandardDocumentPerformingSheetCreatingService
  .RaiseExceptionIfPerformerIsOneOfDocumentSigners(
    Document: IDocument;
    Performer, Issuer: TEmployee
  );
begin

  if
    not
    TDocument(Document.Self)
    .Specifications
      .DocumentSigningSpecification
        .IsEmployeeAnyOfDocumentSigners(Performer, Document)

  then Exit;

  { Refactor: не нужные зависимости, обусловленные
    реализацией спецификации
    StandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification }
      
  if Issuer.IsSecretarySignerFor(Performer) or Performer.IsSecretarySigner
  then Exit;

  raise TDocumentChargeSheetCreatingServiceException.CreateFmt(
        'Сотрудник "%s" не может выдать ' +
        'поручение по документу ' +
        'сотруднику "%s", поскольку ' +
        'последний является исполняющим ' +
        'обязанности для ' +
        'подписанта этого документа',
        [
          Issuer.FullName,
          Performer.FullName
        ]
      );

end;

end.
