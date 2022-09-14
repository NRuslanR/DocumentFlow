unit StandardDocumentApproverSetReadService;

interface

uses

  AbstractDocumentEmployeeSetReadService,
  DocumentApproverSetReadService,
  EmployeeSetReadService,
  EmployeeSetHolder,
  SysUtils,
  Classes;

type

  TStandardDocumentApproverSetReadService =
    class (TAbstractDocumentEmployeeSetReadService, IDocumentApproverSetReadService)

      public

        function GetDocumentApproverSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder; virtual;
        
    end;


implementation

{ TStandardDocumentApproverSetReadService }

function TStandardDocumentApproverSetReadService.
  GetDocumentApproverSetForEmployee(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;
begin

  Result := FEmployeeSetReadService.GetAllNotForeignEmployeeSet;
  
end;

end.
