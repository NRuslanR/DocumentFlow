unit StandardDocumentChargeSheetIssuingAccessRightsService;

interface

uses

  DocumentChargeSheetIssuingAccessRightsService,
  Document,
  DocumentChargeKind,
  Employee,
  DomainObjectValueUnit,
  DomainException,
  IDomainObjectBaseListUnit,
  DocumentChargeSheetIssuingAccessRights,
  DocumentChargeKindsControlService,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  IDomainObjectBaseUnit,
  Hashes,
  SysUtils;

type

  TStandardDocumentChargeSheetIssuingAccessRightsService =
    class (TInterfacedObject, IDocumentChargeSheetIssuingAccessRightsService)

      private

        FAlloweableChargeSheetKindsIssuingSpecs: TObjectHash;

        procedure CreateAlloweableChargeSheetKindsIssuingSpecifications;

        procedure SetAlloweableChargeSheetKinds(
          IssuingAccessRights: TDocumentChargeSheetIssuingAccessRights;
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
          AlloweableChargeKinds: TDocumentChargeKinds
        );
        
      private

        FChargeKindsControlService: IDocumentChargeKindsControlService;

        procedure RaiseExceptionIfGeneralChargeSheetsAccessRightsNotValid(
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        );
        
        function GetMainChargeSheetKind(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): TDocumentChargeKind;

      public

        destructor Destroy; override;
        constructor Create(ChargeKindsControlService: IDocumentChargeKindsControlService);
        
        function GetDocumentChargeSheetIssuingAccessRights(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): TDocumentChargeSheetIssuingAccessRights;

        function EnsureEmployeeHasDocumentChargeSheetIssuingAccessRights(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): TDocumentChargeSheetIssuingAccessRights;

    end;

implementation

uses

  DocumentAcquaitance,
  DocumentPerforming,
  DocumentSpecifications,
  DocumentSigningSpecification,
  ServiceNote,
  IncomingServiceNote;

type

  IAlloweableDocumentChargeSheetKindIssuingSpecification = interface

    function IsHeadChargeSheetIssuingSatisfiedFor(
      Document: TDocument;
      Employee: TEmployee;
      GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
    ): Boolean;

    function IsSubordinateChargeSheetIssuingSatisfiedFor(
      Document: TDocument;
      Employee: TEmployee;
      GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
    ): Boolean;

  end;

  TAlloweableDocumentChargeSheetKindIssuingSpecification =
    class abstract (TInterfacedObject, IAlloweableDocumentChargeSheetKindIssuingSpecification)

      protected

        function InternalIsHeadChargeSheetIssuingSatisfiedFor(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): Boolean; virtual; abstract;

        function IsDocumentStateValidForHeadChargeSheetIssuing(Document: TDocument): Boolean; virtual;

      protected

        function InternalIsSubordinateChargeSheetIssuingSatisfiedFor(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): Boolean; virtual; abstract;

        function IsDocumentStateValidForSubordinateChargeSheetIssuing(Document: TDocument): Boolean; virtual;

      public

        function IsHeadChargeSheetIssuingSatisfiedFor(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): Boolean;

        function IsSubordinateChargeSheetIssuingSatisfiedFor(
          Document: TDocument;
          Employee: TEmployee;
          GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
        ): Boolean;

    end;

    TAlloweableDocumentAcquaitanceSheetKindIssuingSpecification =
      class (TAlloweableDocumentChargeSheetKindIssuingSpecification)

        protected

          function InternalIsHeadChargeSheetIssuingSatisfiedFor(
            Document: TDocument;
            Employee: TEmployee;
            GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
          ): Boolean; override;

          function InternalIsSubordinateChargeSheetIssuingSatisfiedFor(
            Document: TDocument;
            Employee: TEmployee;
            GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
          ): Boolean; override;

      end;

    TAlloweableDocumentPerformingSheetKindIssuingSpecification =
      class (TAlloweableDocumentChargeSheetKindIssuingSpecification)

        protected

          function InternalIsHeadChargeSheetIssuingSatisfiedFor(
            Document: TDocument;
            Employee: TEmployee;
            GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
          ): Boolean; override;

          function IsDocumentStateValidForHeadChargeSheetIssuing(Document: TDocument): Boolean; override;

        protected

          function InternalIsSubordinateChargeSheetIssuingSatisfiedFor(
            Document: TDocument;
            Employee: TEmployee;
            GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
          ): Boolean; override;

          function IsDocumentStateValidForSubordinateChargeSheetIssuing(Document: TDocument): Boolean; override;

      end;

{ TStandardDocumentChargeSheetIssuingAccessRightsService }

constructor TStandardDocumentChargeSheetIssuingAccessRightsService.Create(
  ChargeKindsControlService: IDocumentChargeKindsControlService);
begin

  inherited Create;

  FChargeKindsControlService := ChargeKindsControlService;

  CreateAlloweableChargeSheetKindsIssuingSpecifications;
  
end;

procedure TStandardDocumentChargeSheetIssuingAccessRightsService
  .CreateAlloweableChargeSheetKindsIssuingSpecifications;
begin

  FAlloweableChargeSheetKindsIssuingSpecs := TObjectHash.Create;

  FAlloweableChargeSheetKindsIssuingSpecs[TDocumentPerforming.ClassName] :=
    TAlloweableDocumentPerformingSheetKindIssuingSpecification.Create;

  FAlloweableChargeSheetKindsIssuingSpecs[TDocumentAcquaitance.ClassName] :=
    TAlloweableDocumentAcquaitanceSheetKindIssuingSpecification.Create;
    
end;

destructor TStandardDocumentChargeSheetIssuingAccessRightsService.Destroy;
begin

  FreeAndNil(FAlloweableChargeSheetKindsIssuingSpecs);
  
  inherited;

end;

function TStandardDocumentChargeSheetIssuingAccessRightsService
  .EnsureEmployeeHasDocumentChargeSheetIssuingAccessRights(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): TDocumentChargeSheetIssuingAccessRights;
begin

  Result :=
    GetDocumentChargeSheetIssuingAccessRights(
      Document, Employee, GeneralChargeSheetsAccessRights
    );

  if Result.AllAccessRightsAbsent then begin

    Result.Free;
    
    raise TDocumentChargeSheetIssuingAccessRightsServiceException.Create(
      'ќтсутствуют права на выдачу поручений на документ'
    );

  end;

end;

function TStandardDocumentChargeSheetIssuingAccessRightsService
  .GetDocumentChargeSheetIssuingAccessRights(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): TDocumentChargeSheetIssuingAccessRights;
var
    AlloweableChargeKinds: TDocumentChargeKinds;
    FreeAlloweableChargeKinds: IDomainObjectBaseList;
begin

  AlloweableChargeKinds :=
    FChargeKindsControlService.FindAllowedDocumentChargeKindsForDocument(Document);

  FreeAlloweableChargeKinds := AlloweableChargeKinds;
  
  Result := TDocumentChargeSheetIssuingAccessRights.Create;

  try

    SetAlloweableChargeSheetKinds(
      Result,
      Document,
      Employee,
      GeneralChargeSheetsAccessRights,
      AlloweableChargeKinds
    );

    Result.MainChargeSheetKind :=
      GetMainChargeSheetKind(
        Document, Employee, GeneralChargeSheetsAccessRights
      );

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardDocumentChargeSheetIssuingAccessRightsService
  .GetMainChargeSheetKind(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): TDocumentChargeKind;
begin

  Result :=
    FChargeKindsControlService
      .FindMainDocumentChargeKindForDocumentKind(Document.KindIdentity);

end;

procedure TStandardDocumentChargeSheetIssuingAccessRightsService
  .RaiseExceptionIfGeneralChargeSheetsAccessRightsNotValid(
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  );
begin

  if GeneralChargeSheetsAccessRights.AllChargeSheetsAccessRightsAbsent then begin

    raise TDocumentChargeSheetIssuingAccessRightsServiceException.Create(
      'Ќевозможно определить права на выдачу поручений, ' +
      'поскольку отсутствуют права на доступ к ' +
      'текущим поручени€м сотрудника'
    );

  end;

end;

procedure TStandardDocumentChargeSheetIssuingAccessRightsService.SetAlloweableChargeSheetKinds(
  IssuingAccessRights: TDocumentChargeSheetIssuingAccessRights;
  Document: TDocument;
  Employee: TEmployee;
  GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;
  AlloweableChargeKinds: TDocumentChargeKinds
);
var
    ChargeKind: TDocumentChargeKind;
    AlloweableChargeSheetKindSpec: TAlloweableDocumentChargeSheetKindIssuingSpecification;
begin

  for ChargeKind in AlloweableChargeKinds do begin

    if
      not
      FAlloweableChargeSheetKindsIssuingSpecs.Exists(
        ChargeKind.ChargeClass.ClassName
      )
    then Exit;
    
    AlloweableChargeSheetKindSpec :=
      TAlloweableDocumentChargeSheetKindIssuingSpecification(
        FAlloweableChargeSheetKindsIssuingSpecs[ChargeKind.ChargeClass.ClassName]
      );

    if
      AlloweableChargeSheetKindSpec.IsHeadChargeSheetIssuingSatisfiedFor(
        Document, Employee, GeneralChargeSheetsAccessRights
      )
    then begin

      IssuingAccessRights.IssuingAlloweableHeadChargeSheetKinds.Add(ChargeKind);

    end;

    if
      AlloweableChargeSheetKindSpec.IsSubordinateChargeSheetIssuingSatisfiedFor(
        Document, Employee, GeneralChargeSheetsAccessRights
      )
    then begin

      IssuingAccessRights
        .IssuingAlloweableSubordinateChargeSheetKinds.Add(ChargeKind);
      
    end;

  end;

end;

{ TAlloweableDocumentChargeSheetKindIssuingSpecification }

function TAlloweableDocumentChargeSheetKindIssuingSpecification
  .IsDocumentStateValidForHeadChargeSheetIssuing(
    Document: TDocument
  ): Boolean;
begin

  Result := Document.IsSigned;

end;

function TAlloweableDocumentChargeSheetKindIssuingSpecification
  .IsDocumentStateValidForSubordinateChargeSheetIssuing(
    Document: TDocument
  ): Boolean;
begin

  Result := Document.IsSigned;
  
end;

function TAlloweableDocumentChargeSheetKindIssuingSpecification
  .IsHeadChargeSheetIssuingSatisfiedFor(
    Document: TDocument; Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): Boolean;
begin

  Result :=
    IsDocumentStateValidForHeadChargeSheetIssuing(Document)
    and InternalIsHeadChargeSheetIssuingSatisfiedFor(
      Document, Employee, GeneralChargeSheetsAccessRights
    );

end;

function TAlloweableDocumentChargeSheetKindIssuingSpecification
  .IsSubordinateChargeSheetIssuingSatisfiedFor(
    Document: TDocument; Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): Boolean;
begin

  Result :=
    IsDocumentStateValidForSubordinateChargeSheetIssuing(Document)
    and InternalIsSubordinateChargeSheetIssuingSatisfiedFor(
      Document, Employee, GeneralChargeSheetsAccessRights
    );

end;

{ TAlloweableDocumentAcquaitanceSheetKindIssuingSpecification }

function TAlloweableDocumentAcquaitanceSheetKindIssuingSpecification
  .InternalIsHeadChargeSheetIssuingSatisfiedFor(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): Boolean;
begin

  Result :=
    Document
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
            Employee, Document
          );

end;

function TAlloweableDocumentAcquaitanceSheetKindIssuingSpecification
  .InternalIsSubordinateChargeSheetIssuingSatisfiedFor(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): Boolean;
begin

  Result :=
    GeneralChargeSheetsAccessRights.AnyChargeSheetsCanBeViewedAsIssuer
    or GeneralChargeSheetsAccessRights.AnyChargeSheetsCanBeViewedAsPerformer;

end;

{ TAlloweableDocumentPerformingSheetKindIssuingSpecification }

function TAlloweableDocumentPerformingSheetKindIssuingSpecification
  .InternalIsHeadChargeSheetIssuingSatisfiedFor(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): Boolean;
begin

  Result :=
    Document
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
            Employee, Document
          );
          
end;

function TAlloweableDocumentPerformingSheetKindIssuingSpecification
  .InternalIsSubordinateChargeSheetIssuingSatisfiedFor(
    Document: TDocument;
    Employee: TEmployee;
    GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
  ): Boolean;
begin

  Result :=
    GeneralChargeSheetsAccessRights.AnyChargeSheetsCanBePerformed;

end;

function TAlloweableDocumentPerformingSheetKindIssuingSpecification
  .IsDocumentStateValidForHeadChargeSheetIssuing(
    Document: TDocument
  ): Boolean;
begin

  Result :=
    inherited IsDocumentStateValidForHeadChargeSheetIssuing(Document)
    and not (Document.IsPerforming or Document.IsPerformed);

end;

function TAlloweableDocumentPerformingSheetKindIssuingSpecification
  .IsDocumentStateValidForSubordinateChargeSheetIssuing(
    Document: TDocument
  ): Boolean;
begin

end;

end.
