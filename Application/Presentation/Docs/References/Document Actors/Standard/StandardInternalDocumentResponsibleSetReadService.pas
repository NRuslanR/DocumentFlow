unit StandardInternalDocumentResponsibleSetReadService;

interface

uses

  StandardDocumentResponsibleSetReadService,
  EmployeeSetHolder,
  SysUtils,
  Classes;

type

  TStandardInternalDocumentResponsibleSetReadService =
    class (TStandardDocumentResponsibleSetReadService)

      public

        function GetDocumentResponsibleSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder; override;

    end;
    
implementation

uses AbstractDocumentEmployeeSetReadService;

{ TStandardInternalDocumentResponsibleSetReadService }

function TStandardInternalDocumentResponsibleSetReadService.
  GetDocumentResponsibleSetForEmployee(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result :=
    FEmployeeSetReadService.
      GetAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
        EmployeeId
      );

end;

end.
