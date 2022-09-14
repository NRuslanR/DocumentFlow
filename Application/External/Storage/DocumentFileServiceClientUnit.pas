{
  Refactor:
  в тех местах, где используются доменные обекты
  произвести замену на DTO, также внедрять
  PathBuilder для формирование путей с именами
  файлов для различных видов документов
}
unit DocumentFileServiceClientUnit;

interface

uses

  AbstractApplicationService,
  IDocumentFileServiceClientUnit,
  DocumentFileStorageService,
  SysUtils;

type

  TDocumentFileServiceClient =
    class (TAbstractApplicationService, IDocumentFileServiceClient)

      protected

        FDocumentFileStorageService: IDocumentFileStorageService;

      public

        destructor Destroy; override;
        
        constructor Create(
          DocumentFileStorageService: IDocumentFileStorageService
        );

        function GetFileStoragePath: String;

        function GetFile(const DocumentFileId: Variant): String;

    end;

implementation

uses

  AuxDebugFunctionsUnit;

{ TDocumentFileServiceClient }

constructor TDocumentFileServiceClient.Create(
  DocumentFileStorageService: IDocumentFileStorageService);
begin

  inherited Create;

  FDocumentFileStorageService := DocumentFileStorageService;
  
end;

destructor TDocumentFileServiceClient.Destroy;
begin
  
  inherited;

end;

function TDocumentFileServiceClient.GetFile(
  const DocumentFileId: Variant): String;
begin

  Result := FDocumentFileStorageService.GetFile(DocumentFileId);
  
end;

function TDocumentFileServiceClient.GetFileStoragePath: String;
begin

  Result := FDocumentFileStorageService.FileStoragePath;
  
end;

end.
