unit DomainRegistries;

interface

uses

  DocumentsDomainRegistries,
  EmployeesDomainRegistries,
  SysUtils;

type

  TDomainRegistries = class

    public

      class procedure Destroy;
      
      class function DocumentsDomainRegistries: TDocumentsDomainRegistriesClass;
      class function EmployeesDomainRegistries: TEmployeesDomainRegistriesClass;
      
  end;
  
implementation

{ TDomainRegistries }

class procedure TDomainRegistries.Destroy;
begin

  DocumentsDomainRegistries.Destroy;
  EmployeesDomainRegistries.Destroy;
  
end;

class function TDomainRegistries.DocumentsDomainRegistries: TDocumentsDomainRegistriesClass;
begin

  Result := TDocumentsDomainRegistries;

end;

class function TDomainRegistries.EmployeesDomainRegistries: TEmployeesDomainRegistriesClass;
begin

  Result := TEmployeesDomainRegistries;

end;

end.
