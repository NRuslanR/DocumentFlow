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
  Role,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetPerformerSetReadService =
    class (
      TStandardDocumentChargePerformerSetReadService,
      IDocumentChargeSheetPerformerSetReadService
    )

      protected

        function GetChargePerformingUnitForEmployee(
          Employee: TEmployee
        ): TEmployeeChargePerformingUnit; override;

      public

        function FindDocumentChargeSheetPerformerSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder;

    end;

implementation

uses

  VariantListUnit,
  IDomainObjectUnit,
  IDomainObjectListUnit;

{ TStandardDocumentChargeSheetPerformerSetReadService }

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

end.
