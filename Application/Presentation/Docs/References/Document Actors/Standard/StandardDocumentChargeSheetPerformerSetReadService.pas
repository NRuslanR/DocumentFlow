unit StandardDocumentChargeSheetPerformerSetReadService;

interface

uses

  EmployeeChargePerformingService,
  IEmployeeRepositoryUnit,
  EmployeeSetReadService,
  DocumentChargePerformerSetReadService,
  EmployeeSetHolder,
  StandardDocumentChargePerformerSetReadService,
  DocumentChargeSheetPerformerSetReadService,
  Employee,
  EmployeeStaff,
  EmployeeStaffDto,
  EmployeeChargePerformingUnit,
  EmployeeChargePerformingUnitDto,
  DocumentDirectory,
  IDocumentUnit,
  Document,
  Role,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetPerformerSetReadService =
    class (
      TStandardDocumentChargePerformerSetReadService,
      IDocumentChargeSheetPerformerSetReadService
    )

      private

        FDocumentDirectory: IDocumentDirectory;

      protected

        function FindDocumentByIdOrRaise(const DocumentId: Variant): IDocument;

        function GetChargeSheetPerformerSetBy(
          Document: IDocument;
          Employee: TEmployee
        ): TEmployeeSetHolder;

        function FindChargePerformingUnitBy(
          Document: IDocument;
          Employee: TEmployee
        ): TEmployeeChargePerformingUnit;

        function GetChargePerformingUnitForEmployee(
          Employee: TEmployee
        ): TEmployeeChargePerformingUnit; override;

      public

        constructor Create(
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          EmployeeChargePerformingService: IEmployeeChargePerformingService;
          EmployeeSetReadService: IEmployeeSetReadService
        );
        
        function FindDocumentChargeSheetPerformerSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder;

        function FindChargeSheetPerformerSetForDocumentAndEmployee(
          const DocumentId: Variant;
          const EmployeeId: Variant
        ): TEmployeeSetHolder;

    end;

implementation

uses

  VariantListUnit,
  IDomainObjectBaseUnit;

{ TStandardDocumentChargeSheetPerformerSetReadService }

constructor TStandardDocumentChargeSheetPerformerSetReadService.Create(
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  EmployeeChargePerformingService: IEmployeeChargePerformingService;
  EmployeeSetReadService: IEmployeeSetReadService
);
begin

  inherited Create(
    EmployeeRepository,
    EmployeeChargePerformingService,
    EmployeeSetReadService
  );

  FDocumentDirectory := DocumentDirectory;

end;

function TStandardDocumentChargeSheetPerformerSetReadService
  .FindDocumentChargeSheetPerformerSetForEmployee(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result := FindAllPossibleDocumentChargePerformerSetForEmployee(EmployeeId);

end;

function TStandardDocumentChargeSheetPerformerSetReadService.
  GetChargePerformingUnitForEmployee(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
begin

  Result :=
    FEmployeeChargePerformingService.
      FindSubordinateChargePerformingUnitForEmployee(
        Employee
      );

end;

function TStandardDocumentChargeSheetPerformerSetReadService
  .FindChargeSheetPerformerSetForDocumentAndEmployee(
    const DocumentId, EmployeeId: Variant
  ): TEmployeeSetHolder;
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    Document: IDocument;
begin

  Employee := FindEmployeeByIdOrRaise(EmployeeId);

  FreeEmployee := Employee;

  Document := FindDocumentByIdOrRaise(DocumentId);

  Result := GetChargeSheetPerformerSetBy(Document, Employee);

end;

function TStandardDocumentChargeSheetPerformerSetReadService.FindDocumentByIdOrRaise(
  const DocumentId: Variant): IDocument;
begin

  Result := FDocumentDirectory.FindDocumentById(DocumentId);

  if not Assigned(Result) then begin

    Raise TDocumentChargeSheetPerformerSetReadServiceException.Create(
      'Документ не найден '
      // + 'для выборки исполнителей поручений'
    );
    
  end;

end;

function TStandardDocumentChargeSheetPerformerSetReadService
  .GetChargeSheetPerformerSetBy(
    Document: IDocument;
    Employee: TEmployee
  ): TEmployeeSetHolder;
var
    PerformingUnit: TEmployeeChargePerformingUnit;
    Free: IDomainObjectBase;
begin

  PerformingUnit := FindChargePerformingUnitBy(Document, Employee);

  Free := PerformingUnit;

  Result := GetEmployeeSetFromChargePerformingUnit(PerformingUnit);

end;

function TStandardDocumentChargeSheetPerformerSetReadService
  .FindChargePerformingUnitBy(
    Document: IDocument;
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
begin

  if
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
            Employee, Document
          )
  then
    Result := inherited GetChargePerformingUnitForEmployee(Employee)

  else Result := GetChargePerformingUnitForEmployee(Employee);

end;

end.
