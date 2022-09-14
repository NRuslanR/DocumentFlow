unit AbstractDocumentEmployeeSetReadService;

interface

uses

  AbstractApplicationService,
  EmployeeSetReadService,
  SysUtils,
  Classes;

type

  TAbstractDocumentEmployeeSetReadService =
    class abstract (TAbstractApplicationService)

      protected

        FEmployeeSetReadService: IEmployeeSetReadService;

      public

        constructor Create(EmployeeSetReadService: IEmployeeSetReadService);
        
    end;

implementation

{ TAbstractDocumentEmployeeSetReadService }

constructor TAbstractDocumentEmployeeSetReadService.Create(
  EmployeeSetReadService: IEmployeeSetReadService);
begin

  inherited Create;

  FEmployeeSetReadService := EmployeeSetReadService;
  
end;

end.
