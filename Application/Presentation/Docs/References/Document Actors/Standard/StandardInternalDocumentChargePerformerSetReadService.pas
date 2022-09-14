unit StandardInternalDocumentChargePerformerSetReadService;

interface

uses

  StandardDocumentChargePerformerSetReadService,
  Employee,
  EmployeeChargePerformingUnit,
  SysUtils,
  Classes;

type

  TStandardInternalDocumentChargePerformerSetReadService =
    class (TStandardDocumentChargePerformerSetReadService)

      protected

        function GetChargePerformingUnitForEmployee(
          Employee: TEmployee
        ): TEmployeeChargePerformingUnit; override;

    end;
  
implementation

{ TStandardInternalDocumentChargePerformerSetReadService }

function TStandardInternalDocumentChargePerformerSetReadService.
  GetChargePerformingUnitForEmployee(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
begin

  Result :=
    FEmployeeChargePerformingService.
      FindKindredChargePerformingUnitForEmployeeLeader(
        Employee
      );

end;

end.
