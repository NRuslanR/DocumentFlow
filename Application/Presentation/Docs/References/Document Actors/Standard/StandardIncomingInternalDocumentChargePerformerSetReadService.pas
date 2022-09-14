unit StandardIncomingInternalDocumentChargePerformerSetReadService;

interface

uses

  StandardInternalDocumentChargePerformerSetReadService,
  EmployeeChargePerformingUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardIncomingInternalDocumentChargePerformerSetReadService =
    class (TStandardInternalDocumentChargePerformerSetReadService)

      protected

        function GetChargePerformingUnitForEmployee(
          Employee: TEmployee
        ): TEmployeeChargePerformingUnit; override;

    end;
    
implementation

uses StandardDocumentChargePerformerSetReadService;

{ TStandardIncomingInternalDocumentChargePerformerSetReadService }

function TStandardIncomingInternalDocumentChargePerformerSetReadService.
  GetChargePerformingUnitForEmployee(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
begin

  Result :=
    FEmployeeChargePerformingService.
      FindSubordinateKindredChargePerformingUnitForEmployee(
        Employee
      );

end;

end.
