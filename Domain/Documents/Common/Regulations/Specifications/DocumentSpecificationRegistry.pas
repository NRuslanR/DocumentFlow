unit DocumentSpecificationRegistry;

interface

uses

  DocumentSigningSpecification,
  DocumentChargesSpecification,
  DocumentPerformingSpecification,
  TypeObjectRegistry,
  DocumentSpecifications,
  Document,
  SysUtils;

type

  TDocumentSpecificationRegistry = class

    private

      class var FInstance: TDocumentSpecificationRegistry;

      class function GetInstance: TDocumentSpecificationRegistry; static;

    private

      FDocumentSigningSpecifications: TTypeObjectRegistry;
      FDocumentChargesSpecifications: TTypeObjectRegistry;
      FDocumentPerformingSpecifications: TTypeObjectRegistry;
      
    public

      procedure RegisterDocumentSigningSpecification(
        DocumentKind: TDocumentClass;
        DocumentSigningSpecification: IDocumentSigningSpecification
      );

      function GetDocumentSigningSpecification(
        DocumentKind: TDocumentClass
      ): IDocumentSigningSpecification;

      procedure RegisterStandardDocumentSigningSpecification(
        DocumentKind: TDocumentClass
      );

    public

      procedure RegisterDocumentChargesSpecification(
        DocumentKind: TDocumentClass;
        DocumentChargesSpecification: IDocumentChargesSpecification
      );

      function GetDocumentChargesSpecification(
        DocumentKind: TDocumentClass
      ): IDocumentChargesSpecification;

      procedure RegisterStandardDocumentChargesSpecification(
        DocumentKind: TDocumentClass
      );

    public

      procedure RegisterDocumentPerformingSpecification(
        DocumentKind: TDocumentClass;
        DocumentPerformingSpecification: IDocumentPerformingSpecification
      );

      function GetDocumentPerformingSpecification(
        DocumentKind: TDocumentClass
      ): IDocumentPerformingSpecification;

      procedure RegisterStandardDocumentPerformingSpecification(
        DocumentKind: TDocumentClass
      );

    public

      procedure RegisterAllStandardDocumentSpecifications(DocumentKind: TDocumentClass);

    public

      function GetDocumentSpecifications(DocumentKind: TDocumentClass): IDocumentSpecifications;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentSpecificationRegistry
      read GetInstance write FInstance;
      
  end;

  TDocumentSpecificationRegistryClass = class of TDocumentSpecificationRegistry;

implementation

uses

  PersonnelOrder,
  PersonnelOrderControlServiceRegistry,
  DocumentChargeSheetsServiceRegistry,
  EmployeeSubordinationSpecificationRegistry,
  StandardPersonnelOrderSigningSpecification,
  StandardDocumentSigningSpecification,
  StandardDocumentChargesSpecification,
  StandardDocumentPerformingSpecification;
  
{ TDocumentSpecificationRegistry }

constructor TDocumentSpecificationRegistry.Create;
begin

  inherited;

  FDocumentSigningSpecifications := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargesSpecifications := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentPerformingSpecifications := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentSigningSpecifications.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentChargesSpecifications.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentPerformingSpecifications.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentSpecificationRegistry.Destroy;
begin

  FreeAndNil(FDocumentSigningSpecifications);
  FreeAndNil(FDocumentChargesSpecifications);
  FreeAndNil(FDocumentPerformingSpecifications);
  
  inherited;

end;

function TDocumentSpecificationRegistry.GetDocumentChargesSpecification(
  DocumentKind: TDocumentClass): IDocumentChargesSpecification;
begin

  Result :=
    IDocumentChargesSpecification(
      FDocumentChargesSpecifications.GetInterface(DocumentKind)
    );

end;

function TDocumentSpecificationRegistry.GetDocumentPerformingSpecification(
  DocumentKind: TDocumentClass): IDocumentPerformingSpecification;
begin

  Result :=
    IDocumentPerformingSpecification(
      FDocumentPerformingSpecifications.GetInterface(DocumentKind)
    );
    
end;

function TDocumentSpecificationRegistry.GetDocumentSigningSpecification(
  DocumentKind: TDocumentClass): IDocumentSigningSpecification;
begin

  Result :=
    IDocumentSigningSpecification(
      FDocumentSigningSpecifications.GetInterface(DocumentKind)
    );

end;

function TDocumentSpecificationRegistry.GetDocumentSpecifications(
  DocumentKind: TDocumentClass): IDocumentSpecifications;
begin

  Result :=
    TDocumentSpecifications.Create(
      GetDocumentSigningSpecification(DocumentKind),
      GetDocumentChargesSpecification(DocumentKind),
      GetDocumentPerformingSpecification(DocumentKind)
    );
    
end;

class function TDocumentSpecificationRegistry.GetInstance: TDocumentSpecificationRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentSpecificationRegistry.Create;
    
  Result := FInstance;

end;

procedure TDocumentSpecificationRegistry.RegisterAllStandardDocumentSpecifications(DocumentKind: TDocumentClass);
begin

  RegisterStandardDocumentChargesSpecification(DocumentKind);
  RegisterStandardDocumentSigningSpecification(DocumentKind);
  RegisterStandardDocumentPerformingSpecification(DocumentKind);

end;

procedure TDocumentSpecificationRegistry.RegisterDocumentChargesSpecification(
  DocumentKind: TDocumentClass;
  DocumentChargesSpecification: IDocumentChargesSpecification);
begin

  FDocumentChargesSpecifications.RegisterInterface(
    DocumentKind,
    DocumentChargesSpecification
  );
  
end;

procedure TDocumentSpecificationRegistry.RegisterDocumentPerformingSpecification(
  DocumentKind: TDocumentClass;
  DocumentPerformingSpecification: IDocumentPerformingSpecification);
begin

  FDocumentPerformingSpecifications.RegisterInterface(
    DocumentKind,
    DocumentPerformingSpecification
  );
  
end;

procedure TDocumentSpecificationRegistry.RegisterDocumentSigningSpecification(
  DocumentKind: TDocumentClass;
  DocumentSigningSpecification: IDocumentSigningSpecification);
begin

  FDocumentSigningSpecifications.RegisterInterface(
    DocumentKind,
    DocumentSigningSpecification
  );

end;

procedure TDocumentSpecificationRegistry.RegisterStandardDocumentChargesSpecification(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentChargesSpecification(
    DocumentKind,
    TStandardDocumentChargesSpecification.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification
    )
  );

end;

procedure TDocumentSpecificationRegistry.RegisterStandardDocumentPerformingSpecification(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentPerformingSpecification(
    DocumentKind,
    TStandardDocumentPerformingSpecification.Create(
      TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetDirectory(DocumentKind)
    )
  );

end;

procedure TDocumentSpecificationRegistry.RegisterStandardDocumentSigningSpecification(
  DocumentKind: TDocumentClass);
begin

  if DocumentKind.InheritsFrom(TPersonnelOrder) then begin

    RegisterDocumentSigningSpecification(
      DocumentKind,
      TStandardPersonnelOrderSigningSpecification.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
        TPersonnelOrderControlServiceRegistry.Instance.GetPersonnelOrderControlService
      )
    );

  end

  else begin

    RegisterDocumentSigningSpecification(
      DocumentKind,
      TStandardDocumentSigningSpecification.Create(
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification
      )
    );

  end;

end;

end.
