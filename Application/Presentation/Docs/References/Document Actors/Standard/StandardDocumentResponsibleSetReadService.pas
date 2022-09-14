unit StandardDocumentResponsibleSetReadService;

interface

uses

  AbstractDocumentEmployeeSetReadService,
  EmployeeSetReadService,
  DocumentResponsibleSetReadService,
  EmployeeSetHolder,
  SysUtils,
  Classes;

type

  TStandardDocumentResponsibleSetReadService =
    class (TAbstractDocumentEmployeeSetReadService, IDocumentResponsibleSetReadService)

      public

        function GetDocumentResponsibleSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder; virtual;

    end;

implementation

{ TStandardDocumentResponsibleSetReadService }

function TStandardDocumentResponsibleSetReadService.
  GetDocumentResponsibleSetForEmployee(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result := FEmployeeSetReadService.GetAllPlantEmployeeSet;

end;

end.
