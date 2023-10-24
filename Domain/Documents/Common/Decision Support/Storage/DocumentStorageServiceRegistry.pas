unit DocumentStorageServiceRegistry;

interface

uses

  DocumentFinder,
  DocumentFileMetadataDirectory,
  DocumentFileStorageService,
  DocumentRelationDirectory,
  DocumentResponsibleDirectory,
  DocumentApprovingCycleResultDirectory,
  DocumentDirectory,
  DocumentKindFinder,
  TypeObjectRegistry,
  IFileStorageServiceClientUnit,
  OriginalDocumentFinder,
  DocumentKind,
  Document,
  SysUtils;
  
type

  TDocumentStorageServiceRegistry = class

    private

      class var FInstance: TDocumentStorageServiceRegistry;

      class function GetInstance: TDocumentStorageServiceRegistry; static;

    private

      FOriginalDocumentDirectories: TTypeObjectRegistry;
      FTypeServiceRegistry: TTypeObjectRegistry;
      FDocumentFileMetadataDirectoryRegistry: TTypeObjectRegistry;
      FDocumentRelationDirectoryRegistry: TTypeObjectRegistry;
      FDocumentFileStorageServiceRegistry: TTypeObjectRegistry;
      FDocumentApprovingCycleResultDirectoryRegistry: TTypeObjectRegistry;
      FDocumentDirectoryRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentFileMetadataDirectory(
        DocumentType: TDocumentClass;
        DocumentFileMetadataDirectory: IDocumentFileMetadataDirectory
      );

      function GetDocumentFileMetadataDirectory(
        DocumentType: TDocumentClass
      ): IDocumentFileMetadataDirectory;

    public

      procedure RegisterDocumentRelationDirectory(
        DocumentType: TDocumentClass;
        DocumentRelationDirectory: IDocumentRelationDirectory
      );

      function GetDocumentRelationDirectory(
        DocumentType: TDocumentClass
      ): IDocumentRelationDirectory;

    public

      procedure RegisterDocumentResponsibleDirectory(
        DocumentResponsibleDirectory: IDocumentResponsibleDirectory
      );

      function GetDocumentResponsibleDirectory: IDocumentResponsibleDirectory;

    public

      procedure RegisterDocumentFileStorageService(
        DocumentType: TDocumentClass;
        DocumentFileStorageService: IDocumentFileStorageService
      );

      function GetDocumentFileStorageService(
        DocumentType: TDocumentClass
      ): IDocumentFileStorageService;

      procedure RegisterStandardDocumentFileStorageService(
        DocumentType: TDocumentClass;
        FileStorageServiceClient: IFileStorageServiceClient
      );
      
    public

      procedure RegisterDocumentDirectory(
        DocumentType: TDocumentClass;
        DocumentDirectory: IDocumentDirectory
      );

      function GetDocumentDirectory(
        DocumentType: TDocumentClass
      ): IDocumentDirectory;

    public

      procedure RegisterOriginalDocumentDirectory(
        DocumentType: TDocumentClass;
        DocumentDirectory: IDocumentDirectory
      );

      function GetOriginalDocumentDirectory(
        DocumentType: TDocumentClass
      ): IDocumentDirectory;
      
    public

      procedure RegisterDocumentApprovingCycleResultDirectory(
        DocumentType: TDocumentClass;
        DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory
      );

      function GetDocumentApprovingCycleResultDirectory(
        DocumentType: TDocumentClass
      ): IDocumentApprovingCycleResultDirectory;

    public

      constructor Create;
      destructor Destroy; override;

      class property Instance: TDocumentStorageServiceRegistry
      read GetInstance;

  end;

implementation

uses

  Classes,
  IDomainObjectBaseListUnit,
  Windows,
  DocumentSearchServiceRegistry,
  StandardDocumentFileStorageService;

type

  TDocumentResponsibleDirectoryType = class
  
  end;

{ TDocumentStorageServiceRegistry }

constructor TDocumentStorageServiceRegistry.Create;
begin

  inherited;

  FTypeServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FOriginalDocumentDirectories := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentDirectoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentFileMetadataDirectoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentRelationDirectoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentFileStorageServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentApprovingCycleResultDirectoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TDocumentStorageServiceRegistry.Destroy;
var
    Item: ITypeObjectRegistryItem;
    FileStorageService: IDocumentFileStorageService;
begin

  for Item in FDocumentFileStorageServiceRegistry do begin

    if
      not Supports(
        Item.RegistryInterface,
        IDocumentFileStorageService,
        FileStorageService
      )
    then Continue;

    FileStorageService.Cleanup;    

  end;

  FreeAndNil(FOriginalDocumentDirectories);
  FreeAndNil(FTypeServiceRegistry);
  FreeAndNil(FDocumentDirectoryRegistry);
  FreeAndNil(FDocumentFileMetadataDirectoryRegistry);
  FreeAndNil(FDocumentRelationDirectoryRegistry);
  FreeAndNil(FDocumentFileStorageServiceRegistry);
  FreeAndNil(FDocumentApprovingCycleResultDirectoryRegistry);

  inherited;

end;

function TDocumentStorageServiceRegistry.
  GetDocumentApprovingCycleResultDirectory(
    DocumentType: TDocumentClass
  ): IDocumentApprovingCycleResultDirectory;
begin

  Result :=
    IDocumentApprovingCycleResultDirectory(
      FDocumentApprovingCycleResultDirectoryRegistry.GetInterface(DocumentType)
    );
    
end;

function TDocumentStorageServiceRegistry.GetDocumentDirectory(
  DocumentType: TDocumentClass): IDocumentDirectory;
begin

  Result := IDocumentDirectory(FDocumentDirectoryRegistry.GetInterface(DocumentType));

end;

function TDocumentStorageServiceRegistry.GetDocumentFileMetadataDirectory(
  DocumentType: TDocumentClass): IDocumentFileMetadataDirectory;
begin

  Result :=
    IDocumentFileMetadataDirectory(
      FDocumentFileMetadataDirectoryRegistry.GetInterface(DocumentType)
    );
    
end;

function TDocumentStorageServiceRegistry.GetDocumentFileStorageService(
  DocumentType: TDocumentClass): IDocumentFileStorageService;
begin

  Result :=
    IDocumentFileStorageService(
      FDocumentFileStorageServiceRegistry.GetInterface(DocumentType)
    );

end;

function TDocumentStorageServiceRegistry.GetDocumentRelationDirectory(
  DocumentType: TDocumentClass): IDocumentRelationDirectory;
begin

  Result :=
    IDocumentRelationDirectory(
      FDocumentRelationDirectoryRegistry.GetInterface(DocumentType)
    );
    
end;

function TDocumentStorageServiceRegistry.GetDocumentResponsibleDirectory: IDocumentResponsibleDirectory;
begin

  Result :=
    IDocumentResponsibleDirectory(
      FTypeServiceRegistry.GetInterface(TDocumentResponsibleDirectoryType)
    );
    
end;

class function TDocumentStorageServiceRegistry.GetInstance: TDocumentStorageServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentStorageServiceRegistry.Create;

  Result := FInstance;
  
end;

function TDocumentStorageServiceRegistry.GetOriginalDocumentDirectory(
  DocumentType: TDocumentClass): IDocumentDirectory;
begin

  Result :=
    IDocumentDirectory(
      FOriginalDocumentDirectories.GetInterface(DocumentType)
    );
    
end;

procedure TDocumentStorageServiceRegistry.RegisterDocumentApprovingCycleResultDirectory(
  DocumentType: TDocumentClass;
  DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory
);
begin

  FDocumentApprovingCycleResultDirectoryRegistry.RegisterInterface(
    DocumentType,
    DocumentApprovingCycleResultDirectory
  );

end;

procedure TDocumentStorageServiceRegistry.RegisterDocumentDirectory(
  DocumentType: TDocumentClass; DocumentDirectory: IDocumentDirectory);
begin

  FDocumentDirectoryRegistry.RegisterInterface(
    DocumentType,
    DocumentDirectory
  );
  
end;

procedure TDocumentStorageServiceRegistry.RegisterDocumentFileMetadataDirectory(
  DocumentType: TDocumentClass;
  DocumentFileMetadataDirectory: IDocumentFileMetadataDirectory
);
begin

  FDocumentFileMetadataDirectoryRegistry.RegisterInterface(
    DocumentType,
    DocumentFileMetadataDirectory
  );
  
end;

procedure TDocumentStorageServiceRegistry.RegisterDocumentFileStorageService(
  DocumentType: TDocumentClass;
  DocumentFileStorageService: IDocumentFileStorageService);
begin

  FDocumentFileStorageServiceRegistry.RegisterInterface(
    DocumentType,
    DocumentFileStorageService
  );
  
end;

procedure TDocumentStorageServiceRegistry.RegisterDocumentRelationDirectory(
  DocumentType: TDocumentClass;
  DocumentRelationDirectory: IDocumentRelationDirectory);
begin

  FDocumentRelationDirectoryRegistry.RegisterInterface(
    DocumentType, DocumentRelationDirectory
  );
  
end;

procedure TDocumentStorageServiceRegistry.RegisterDocumentResponsibleDirectory(
  DocumentResponsibleDirectory: IDocumentResponsibleDirectory);
begin

  FTypeServiceRegistry.RegisterInterface(
    TDocumentResponsibleDirectoryType, DocumentResponsibleDirectory
  );
  
end;

procedure TDocumentStorageServiceRegistry
  .RegisterOriginalDocumentDirectory(
    DocumentType: TDocumentClass;
    DocumentDirectory: IDocumentDirectory
  );
begin

  FOriginalDocumentDirectories.RegisterInterface(
    DocumentType,
    DocumentDirectory
  );

end;

procedure TDocumentStorageServiceRegistry.RegisterStandardDocumentFileStorageService(
  DocumentType: TDocumentClass;
  FileStorageServiceClient: IFileStorageServiceClient
);
var
    DocumentFileStorageService: IDocumentFileStorageService;
begin

  DocumentFileStorageService :=
    TStandardDocumentFileStorageService.Create(
      FileStorageServiceClient,
      GetDocumentFileMetadataDirectory(DocumentType),

      TStandardDocumentFilePathGenerator.Create(
        DocumentType,
        FileStorageServiceClient.PathBuilder
      )
    );

  RegisterDocumentFileStorageService(
    DocumentType,
    DocumentFileStorageService
  );
  
end;

end.
