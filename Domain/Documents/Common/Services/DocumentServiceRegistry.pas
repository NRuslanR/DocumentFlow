unit DocumentServiceRegistry;

interface

uses

  DocumentAccessRightsServiceRegistry,
  DocumentApprovingServiceRegistry,
  DocumentChargeSheetsServiceRegistry,
  DocumentFormalizationServiceRegistry,
  DocumentNumerationServiceRegistry,
  DocumentPerformingServiceRegistry,
  DocumentKindReferenceServiceRegistry,
  DocumentSearchServiceRegistry,
  DocumentRegistrationServiceRegistry,
  DocumentRelationsServiceRegistry,
  DocumentOperationServiceRegistry,
  DocumentStorageServiceRegistry,
  DocumentSigningServiceRegistry,
  DocumentChargeServiceRegistry,
  Document,
  DocumentChargeSheet,
  SysUtils;

type

  TDocumentServiceRegistry = class

    public

      class procedure Destroy;
      
      class function DocumentSearchServiceRegistry: TDocumentSearchServiceRegistry;
      class function AccessRightsServiceRegistry: TDocumentAccessRightsServiceRegistry;
      class function ApprovingServiceRegistry: TDocumentApprovingServiceRegistry;
      class function ChargeSheetsServiceRegistry: TDocumentChargeSheetsServiceRegistry;
      class function ChargeServiceRegistry: TDocumentChargeServiceRegistry;
      class function FormalizationServiceRegistry: TDocumentFormalizationServiceRegistry;
      class function NumerationServiceRegistry: TDocumentNumerationServiceRegistry;
      class function SigningServiceRegistry: TDocumentSigningServiceRegistry;
      class function PerformingServiceRegistry: TDocumentPerformingServiceRegistry;
      class function DocumentKindReferenceServiceRegistry: TDocumentKindReferenceServiceRegistry;
      class function RegistrationServiceRegistry: TDocumentRegistrationServiceRegistry;
      class function RelationsServiceRegistry: TDocumentRelationsServiceRegistry;
      class function OperationServiceRegistry: TDocumentOperationServiceRegistry;
      class function StorageServiceRegistry: TDocumentStorageServiceRegistry;

      class procedure RegisterAllStandardDocumentServices(DocumentKind: TDocumentClass);
      
  end;

  TDocumentServiceRegistryClass = class of TDocumentServiceRegistry;

implementation

{ TDocumentServiceRegistry }

class function TDocumentServiceRegistry.AccessRightsServiceRegistry: TDocumentAccessRightsServiceRegistry;
begin

  Result := TDocumentAccessRightsServiceRegistry.Instance;

end;

class function TDocumentServiceRegistry.ApprovingServiceRegistry: TDocumentApprovingServiceRegistry;
begin

  Result := TDocumentApprovingServiceRegistry.Instance;

end;

class function TDocumentServiceRegistry.ChargeServiceRegistry: TDocumentChargeServiceRegistry;
begin

  Result := TDocumentChargeServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.ChargeSheetsServiceRegistry: TDocumentChargeSheetsServiceRegistry;
begin

  Result := TDocumentChargeSheetsServiceRegistry.Instance;
  
end;

class procedure TDocumentServiceRegistry.Destroy;
begin

  DocumentSearchServiceRegistry.Free;
  AccessRightsServiceRegistry.Free;
  ApprovingServiceRegistry.Free;
  ChargeServiceRegistry.Free;
  ChargeSheetsServiceRegistry.Free;
  FormalizationServiceRegistry.Free;
  NumerationServiceRegistry.Free;
  SigningServiceRegistry.Free;
  PerformingServiceRegistry.Free;
  DocumentKindReferenceServiceRegistry.Free;
  RegistrationServiceRegistry.Free;
  RelationsServiceRegistry.Free;
  OperationServiceRegistry.Free;
  StorageServiceRegistry.Free;

end;

class function TDocumentServiceRegistry.DocumentKindReferenceServiceRegistry: TDocumentKindReferenceServiceRegistry;
begin

  Result := TDocumentKindReferenceServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.DocumentSearchServiceRegistry: TDocumentSearchServiceRegistry;
begin

  Result := TDocumentSearchServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.FormalizationServiceRegistry: TDocumentFormalizationServiceRegistry;
begin

  Result := TDocumentFormalizationServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.NumerationServiceRegistry: TDocumentNumerationServiceRegistry;
begin

  Result := TDocumentNumerationServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.OperationServiceRegistry: TDocumentOperationServiceRegistry;
begin

  Result := TDocumentOperationServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.PerformingServiceRegistry: TDocumentPerformingServiceRegistry;
begin

  Result := TDocumentPerformingServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.RegistrationServiceRegistry: TDocumentRegistrationServiceRegistry;
begin

  Result := TDocumentRegistrationServiceRegistry.Instance;
  
end;

class function TDocumentServiceRegistry.RelationsServiceRegistry: TDocumentRelationsServiceRegistry;
begin

  Result := TDocumentRelationsServiceRegistry.Instance;

end;

class function TDocumentServiceRegistry.SigningServiceRegistry: TDocumentSigningServiceRegistry;
begin

  Result := TDocumentSigningServiceRegistry.Instance;

end;

class function TDocumentServiceRegistry.StorageServiceRegistry: TDocumentStorageServiceRegistry;
begin

  Result := TDocumentStorageServiceRegistry.Instance;
  
end;

class procedure TDocumentServiceRegistry.RegisterAllStandardDocumentServices(
  DocumentKind: TDocumentClass
);
begin

  FormalizationServiceRegistry.RegisterAllStandardDocumentFormalizationServices;
  ChargeSheetsServiceRegistry.RegisterAllStandardDocumentChargeSheetsServices(DocumentKind);
  ApprovingServiceRegistry.RegisterAllStandardDocumentApprovingServices(DocumentKind);
  AccessRightsServiceRegistry.RegisterAllStandardDocumentAccessRightsServices(DocumentKind);
  RegistrationServiceRegistry.RegisterStandardDocumentRegistrationService(DocumentKind);
  PerformingServiceRegistry.RegisterAllStandardDocumentPerformingServices(DocumentKind);
  DocumentKindReferenceServiceRegistry.RegisterAllStandardDocumentKindReferenceServices(DocumentKind);
  OperationServiceRegistry.RegisterAllStandardDocumentOperationServices(DocumentKind);

end;

end.
