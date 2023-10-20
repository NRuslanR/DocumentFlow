unit PersonnelOrderDefaultSignerFinder;

interface

uses

  AbstractDocumentDefaultSignerFinder,
  PersonnelOrderSignerListFinder,
  EmployeeFinder,
  PersonnelOrderSignerList,
  Document,
  Employee,
  SysUtils;

type

  TPersonnelOrderDefaultSignerFinder = class (TAbstractDocumentDefaultSignerFinder)

    private

      FSignerListFinder: IPersonnelOrderSignerListFinder;
      FEmployeeFinder: IEmployeeFinder;
      
    public

      constructor Create(
        SignerListFinder: IPersonnelOrderSignerListFinder;
        EmployeeFinder: IEmployeeFinder
      );

      function FindDefaultDocumentSignerFor(
        Document: TDocument;
        Employee: TEmployee
      ): TEmployee; override;

  end;

implementation

uses

  Variants,
  IDomainObjectBaseUnit;
  
{ TPersonnelOrderDefaultSignerFinder }

constructor TPersonnelOrderDefaultSignerFinder.Create(
  SignerListFinder: IPersonnelOrderSignerListFinder;
  EmployeeFinder: IEmployeeFinder);
begin

  inherited Create;

  FSignerListFinder := SignerListFinder;
  FEmployeeFinder := EmployeeFinder;
  
end;

function TPersonnelOrderDefaultSignerFinder.FindDefaultDocumentSignerFor(
  Document: TDocument; Employee: TEmployee): TEmployee;
var
    SignerList: TPersonnelOrderSignerList;
    FreeSignerList: IDomainObjectBase;
begin

  SignerList := FSignerListFinder.FindPersonnelOrderSignerList;

  if not Assigned(SignerList) then begin

    Result := nil;
    Exit;

  end;

  FreeSignerList := SignerList;

  if not VarIsNull(SignerList.DefaultSignerId) then
    Result := FEmployeeFinder.FindEmployee(SignerList.DefaultSignerId)

  else Result := nil;
  
end;

end.
