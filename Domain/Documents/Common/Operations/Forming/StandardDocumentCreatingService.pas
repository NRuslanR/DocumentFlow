unit StandardDocumentCreatingService;

interface

uses

  DocumentCreatingService,
  DocumentWorkCycleFinder,
  EmployeeSubordinationService,
  DocumentKindFinder,
  EmployeeDocumentKindAccessRightsService,
  DocumentDefaultSignerFinder,
  DocumentKind,
  Document,
  DocumentFullNameCompilationService,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  TStandardDocumentCreatingService =
    class (TInterfacedObject, IDocumentCreatingService)

      protected

        FDocumentClass: TDocumentClass;
        FDocumentKindFinder: IDocumentKindFinder;
        FDocumentWorkCycleFinder: IDocumentWorkCycleFinder;
        FDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
        FDocumentDefaultSignerFinder: IDocumentDefaultSignerFinder;
        FDocumentFullNameCompilationService: IDocumentFullNameCompilationService;
        
      public

        constructor Create(
          DocumentClass: TDocumentClass;
          DocumentKindFinder: IDocumentKindFinder;
          DocumentWorkCycleFinder: IDocumentWorkCycleFinder;
          DocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
          DocumentDefaultSignerFinder: IDocumentDefaultSignerFinder;
          DocumentFullNameCompilationService: IDocumentFullNameCompilationService
        );
        
        function CreateDocumentInstanceForEmployee(const Employee: TEmployee): IDocument;
        function CreateDefaultDraftedDocumentForEmployee(const Employee: TEmployee): IDocument;
        
    end;

implementation

uses

  IncomingDocument,
  IDomainObjectBaseUnit,
  DomainRegistries, DocumentsDomainRegistries, DocumentSpecificationRegistry;

{ TStandardDocumentCreatingService }

constructor TStandardDocumentCreatingService.Create(
  DocumentClass: TDocumentClass;
  DocumentKindFinder: IDocumentKindFinder;
  DocumentWorkCycleFinder: IDocumentWorkCycleFinder;
  DocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
  DocumentDefaultSignerFinder: IDocumentDefaultSignerFinder;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService
);
begin

  inherited Create;

  FDocumentClass := DocumentClass;
  FDocumentKindFinder := DocumentKindFinder;
  FDocumentWorkCycleFinder := DocumentWorkCycleFinder;
  FDocumentKindAccessRightsService := DocumentKindAccessRightsService;
  FDocumentDefaultSignerFinder := DocumentDefaultSignerFinder;
  FDocumentFullNameCompilationService := DocumentFullNameCompilationService;
  
end;

function TStandardDocumentCreatingService.CreateDefaultDraftedDocumentForEmployee(
  const Employee: TEmployee
): IDocument;
var
    DefaultSigner: TEmployee;
    FreeDefaultSigner: IDomainObjectBase;
begin

  Result := CreateDocumentInstanceForEmployee(Employee);

  DefaultSigner :=
    FDocumentDefaultSignerFinder.FindDefaultDocumentSignerFor(
      TDocument(Result.Self), Employee
    );

  if Assigned(DefaultSigner) then begin

    FreeDefaultSigner := DefaultSigner;

    Result.AddSigner(DefaultSigner);

  end;

  Result.ResponsibleId := Result.Author.LegacyIdentity;

end;

function TStandardDocumentCreatingService.
  CreateDocumentInstanceForEmployee(const Employee: TEmployee): IDocument;
var
    DocumentKind: TDocumentKind;
    FreeDocumentKind: IDomainObjectBase;
begin

  DocumentKind := FDocumentKindFinder.FindDocumentKindByClassType(FDocumentClass);

  FreeDocumentKind := DocumentKind;

  FDocumentKindAccessRightsService.EnsureThatEmployeeCanCreateDocuments(
    DocumentKind.DocumentClass, Employee
  );
  
  Result := FDocumentClass.Create;

  try

    with TDocument(Result.Self) do begin

      InvariantsComplianceRequested := False;

      WorkingRules :=
        TDomainRegistries
          .DocumentsDomainRegistries
            .RuleRegistry
              .GetEmployeeDocumentWorkingRules(ClassType);

      Specifications :=
        TDomainRegistries
          .DocumentsDomainRegistries
            .SpecificationRegistry
              .GetDocumentSpecifications(ClassType);

      KindIdentity := DocumentKind.Identity;

      Author := Employee;

      WorkCycle :=
        FDocumentWorkCycleFinder
          .FindWorkCycleForDocumentKind(DocumentKind.Identity);

      EditingEmployee := Employee;

      CreationDate := Now;

      FullName :=
        FDocumentFullNameCompilationService.CompileFullNameForDocument(Result);

      InvariantsComplianceRequested := True;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
