unit PersonnelOrderDomainRegistries;

interface

uses

  PersonnelOrderServiceRegistries,
  SysUtils;

type

  TPersonnelOrderDomainRegistries = class

    public

      class procedure Destroy;

      class function ServiceRegistries: TPersonnelOrderServiceRegistriesClass;
      
  end;

  TPersonnelOrderDomainRegistriesClass = class of TPersonnelOrderDomainRegistries;

implementation

{ TPersonnelOrderDomainRegistries }

class procedure TPersonnelOrderDomainRegistries.Destroy;
begin

  ServiceRegistries.Destroy;
  
end;

class function TPersonnelOrderDomainRegistries.ServiceRegistries: TPersonnelOrderServiceRegistriesClass;
begin

  Result := TPersonnelOrderServiceRegistries;
  
end;

end.
