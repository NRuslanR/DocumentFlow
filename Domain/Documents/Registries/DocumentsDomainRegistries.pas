unit DocumentsDomainRegistries;

interface

uses

  DocumentRuleRegistry,
  DocumentServiceRegistry,
  PersonnelOrderDomainRegistries,
  DocumentSpecificationRegistry,
  Document,
  SysUtils;

type

  TDocumentsDomainRegistries = class 

    public

      class procedure Destroy;
      
      class function RuleRegistry: TDocumentRuleRegistryClass;
      class function SpecificationRegistry: TDocumentSpecificationRegistry;
      class function ServiceRegistry: TDocumentServiceRegistryClass;

      class function PersonnelOrderDomainRegistries: TPersonnelOrderDomainRegistriesClass;

  end;

  TDocumentsDomainRegistriesClass = class of TDocumentsDomainRegistries;


implementation

{ TDocumentsDomainRegistries }

class procedure TDocumentsDomainRegistries.Destroy;
begin

  RuleRegistry.Destroy;
  SpecificationRegistry.Destroy;
  ServiceRegistry.Destroy;
  PersonnelOrderDomainRegistries.Destroy;

end;

class function TDocumentsDomainRegistries.PersonnelOrderDomainRegistries: TPersonnelOrderDomainRegistriesClass;
begin

  Result := TPersonnelOrderDomainRegistries;
  
end;

class function TDocumentsDomainRegistries.RuleRegistry: TDocumentRuleRegistryClass;
begin

  Result := TDocumentRuleRegistry;
  
end;

class function TDocumentsDomainRegistries.ServiceRegistry: TDocumentServiceRegistryClass;
begin

  Result := TDocumentServiceRegistry;

end;

class function TDocumentsDomainRegistries.SpecificationRegistry: TDocumentSpecificationRegistry;
begin

  Result := TDocumentSpecificationRegistry.Instance;
  
end;

end.
