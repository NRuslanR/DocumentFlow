unit StandardDocumentDefaultSignerFinder;

interface

uses

  AbstractDocumentDefaultSignerFinder,
  DocumentDefaultSignerFinder,
  EmployeeSubordinationService,
  Document,
  Employee,
  SysUtils;

type

  TStandardDocumentDefaultSignerFinder = class (TAbstractDocumentDefaultSignerFinder)

    private

      FEmployeeSubordinationService: IEmployeeSubordinationService;
      
    public

      constructor Create(EmployeeSubordinationService: IEmployeeSubordinationService);
      
      function FindDefaultDocumentSignerFor(
        Document: TDocument;
        Employee: TEmployee
      ): TEmployee; override;
      
  end;

  
implementation

{ TStandardDocumentDefaultSignerFinder }

constructor TStandardDocumentDefaultSignerFinder.Create(
  EmployeeSubordinationService: IEmployeeSubordinationService);
begin

  inherited Create;

  FEmployeeSubordinationService := EmployeeSubordinationService;
  
end;

function TStandardDocumentDefaultSignerFinder.FindDefaultDocumentSignerFor(
  Document: TDocument; Employee: TEmployee): TEmployee;
begin

  Result :=
    FEmployeeSubordinationService
      .FindHighestSameHeadKindredDepartmentBusinessLeaderForEmployee(Employee); 

end;

end.
