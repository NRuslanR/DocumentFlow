unit StandardDocumentFileStorageService;

interface

uses

  PathBuilder,
  DocumentFileStorageService,
  DocumentFileUnit,
  Document,
  DomainException,
  DocumentFileMetadataDirectory,
  IFileStorageServiceClientUnit,
  FileStorageServiceErrors,
  StrUtils,
  DateUtils,
  Variants,
  SysUtils,
  Classes;

type

  TStandardDocumentFilePathGenerator = class (TInterfacedObject, IDocumentFilePathGenerator)

    protected

      FDocumentType: TDocumentClass;
      FPathBuilder: IPathBuilder;

      function GetDocumentTypePrefixFrom(
        DocumentType: TDocumentClass
      ): String; virtual;

    public

      constructor Create(
        DocumentType: TDocumentClass;
        PathBuilder: IPathBuilder
      );

      function GeneratePathForDocumentFile(
        DocumentFile: TDocumentFile;
        const AdditionalPartOfPath:String = ''
      ): String; virtual;

  end;

  TStandardDocumentFileStorageService = class (TInterfacedObject, IDocumentFileStorageService)

    protected

      FFileStorageServiceClient: IFileStorageServiceClient;
      FDocumentFileMetadataDirectory: IDocumentFileMetadataDirectory;
      FDocumentFilePathGenerator: IDocumentFilePathGenerator;

      function GenerateDocumentFilePathFrom(
        DocumentFile: TDocumentFile;
        const DocumentFileNumber: Integer
      ): String;

    public

      destructor Destroy; override;
      
      constructor Create(
        FileStorageServiceClient: IFileStorageServiceClient;
        DocumentFileMetadataDirectory: IDocumentFileMetadataDirectory;
        DocumentFilePathGenerator: IDocumentFilePathGenerator = nil
      );

      function GetFileStoragePath: String;

      function GetDocumentFilePathGenerator: IDocumentFilePathGenerator;
      procedure SetDocumentFilePathGenerator(Value: IDocumentFilePathGenerator);

      procedure PutDocumentFiles(
        DocumentFiles: TDocumentFiles
      );

      procedure UpdateDocumentFilesFor(
        DocumentFiles: TDocumentFiles;
        const DocumentId: Variant
      );

      procedure Cleanup;
      
      function GetSelf: TObject;
      
      procedure RemoveDocumentFiles(
        DocumentFiles: TDocumentFiles
      );

      function GetFile(const DocumentFileId: Variant): String;
      function GetAllFilesForDocument(const DocumentId: Variant): TDocumentFileStorageInfos;

      procedure RemoveAllFilesForDocument(const DocumentId: Variant);

  end;

implementation

uses

  AuxSystemFunctionsUnit,
  ServiceNote,
  PersonnelOrder,
  InternalServiceNote,
  IncomingServiceNote,
  IncomingInternalServiceNote;
  
{ TStandardDocumentFileStorageService }

procedure TStandardDocumentFileStorageService.Cleanup;
begin

  FFileStorageServiceClient.Cleanup;

end;

constructor TStandardDocumentFileStorageService.Create(
  FileStorageServiceClient: IFileStorageServiceClient;
  DocumentFileMetadataDirectory: IDocumentFileMetadataDirectory;
  DocumentFilePathGenerator: IDocumentFilePathGenerator);
begin

  inherited Create;

  FFileStorageServiceClient := FileStorageServiceClient;
  FDocumentFileMetadataDirectory := DocumentFileMetadataDirectory;
  FDocumentFilePathGenerator := DocumentFilePathGenerator;

end;

destructor TStandardDocumentFileStorageService.Destroy;
begin

  Cleanup;
  
  inherited;

end;

function TStandardDocumentFileStorageService.GenerateDocumentFilePathFrom(
  DocumentFile: TDocumentFile;
  const DocumentFileNumber: Integer
): String;
begin

  Result :=
    FDocumentFilePathGenerator.GeneratePathForDocumentFile(
      DocumentFile,
      IntToStr(DocumentFileNumber)
    );

end;

function TStandardDocumentFileStorageService.GetAllFilesForDocument(
  const DocumentId: Variant
): TDocumentFileStorageInfos;
var DocumentFiles: TDocumentFiles;
    DocumentFile: TDocumentFile;
    LocalDocumentFilePath: String;
begin

  Result := nil;
  DocumentFiles := nil;

  try

    try

      DocumentFiles :=
        FDocumentFileMetadataDirectory.FindDocumentFileMetadatas(DocumentId);

      if not Assigned(DocumentFiles) then Exit;

      Result := TDocumentFileStorageInfos.Create;

      FFileStorageServiceClient.Connect;
      
      for DocumentFile in DocumentFiles do begin

        LocalDocumentFilePath :=
          FFileStorageServiceClient.GetFile(DocumentFile.FilePath, DocumentFile.FileName);

        Result.AddFrom(DocumentFile.FileName, LocalDocumentFilePath);
        
      end;

    except

      on e: Exception do begin

        FreeAndNil(Result);

        if (e is TFileStorageServiceException) or (e is TDomainException)
        then raise TDocumentFileStorageServiceException.Create(e.Message);
        
        raise;

      end;

    end;

  finally

    FreeAndNil(DocumentFiles);

    FFileStorageServiceClient.Disconnect;
    
  end;

end;

function TStandardDocumentFileStorageService.GetDocumentFilePathGenerator: IDocumentFilePathGenerator;
begin

  Result := FDocumentFilePathGenerator;

end;

function TStandardDocumentFileStorageService.GetFile(
  const DocumentFileId: Variant
): String;
var
    DocumentFile: TDocumentFile;
begin

  DocumentFile :=
    FDocumentFileMetadataDirectory.FindDocumentFileMetadataById(DocumentFileId);

  if not Assigned(DocumentFile) then begin

    raise TDocumentFileStorageServiceException.Create(
      'Затребованный документ не найден'
    );

  end;

  FFileStorageServiceClient.Connect;

  try

    try

      Result :=
        FFileStorageServiceClient.GetFile(
          DocumentFile.FilePath, DocumentFile.FileName
        );

    except

      on E: TFileSharingViolationException do begin

        Raise TDocumentFileStorageServiceException.CreateFmt(
          'Файл с именем "%s" уже открыт. ' +
          'Для повторного запроса файла необходимо ' +
          'его закрыть',
          [
            DocumentFile.FileName
          ]
        );

      end; 

    end;
  finally

    FFileStorageServiceClient.Disconnect;
    
  end;

end;

function TStandardDocumentFileStorageService.GetFileStoragePath: String;
begin

  Result := FFileStorageServiceClient.BaseFileStorePath;
  
end;

function TStandardDocumentFileStorageService.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TStandardDocumentFileStorageService.PutDocumentFiles(
  DocumentFiles: TDocumentFiles
);
var DocumentFile, ClonableDocumentFile: TDocumentFile;
    LocalDocumentPath, RemoteDocumentFilePath: String;
    NotSavedDocumentFileNameList: String;
    DocumentFileNumber: Integer;
begin

  FFileStorageServiceClient.Connect;

  try

    DocumentFileNumber := 0;

    for DocumentFile in DocumentFiles do begin

      try

        try

          ClonableDocumentFile := nil;
          
          Inc(DocumentFileNumber);

          RemoteDocumentFilePath :=
            GenerateDocumentFilePathFrom(DocumentFile, DocumentFileNumber);

          ClonableDocumentFile :=
            TClonableDocumentFile.Create(DocumentFile, RemoteDocumentFilePath);

          LocalDocumentPath := DocumentFile.FilePath;

          FDocumentFileMetadataDirectory.PutDocumentFileMetadata(ClonableDocumentFile);
            
          FFileStorageServiceClient.PutFile(
            LocalDocumentPath, RemoteDocumentFilePath
          );

        except

          on e: Exception do begin

            if NotSavedDocumentFileNameList = '' then
              NotSavedDocumentFileNameList := DocumentFile.FileName

            else
              NotSavedDocumentFileNameList :=
                NotSavedDocumentFileNameList + ', ' + DocumentFile.FileName;

          end;

        end;

      finally

        FreeAndNil(ClonableDocumentFile);
        
      end;

      if NotSavedDocumentFileNameList <> '' then begin

        raise TDocumentFileStorageServiceException.Create(
          'Не удалось загрузить следующие файлы ' +
          'на удаленное хранилище:' + sLineBreak +
          NotSavedDocumentFileNameList
        );

      end;

    end;

  finally

    FFileStorageServiceClient.Disconnect;

  end;
  
end;

procedure TStandardDocumentFileStorageService.RemoveAllFilesForDocument(
  const DocumentId: Variant);
var DocumentFiles: TDocumentFiles;
begin

  DocumentFiles :=
    FDocumentFileMetadataDirectory.FindDocumentFileMetadatas(DocumentId);

  if Assigned(DocumentFiles) then
    RemoveDocumentFiles(DocumentFiles);

end;

procedure TStandardDocumentFileStorageService.RemoveDocumentFiles(
  DocumentFiles: TDocumentFiles
);
var
    DocumentFile: TDocumentFile;
    NotRemovedDocumentFileNameList: String;
    NotRemovedFileDescription: String;
begin

  FFileStorageServiceClient.Connect;

  try

    for DocumentFile in DocumentFiles do begin

      try

        FDocumentFileMetadataDirectory.RemoveDocumentFileMetadata(DocumentFile);
        
        FFileStorageServiceClient.RemoveFile(DocumentFile.FilePath);

      except

        on e: TFileStorageServiceException do begin

          if not (e is TFileNotFoundException) then begin

            NotRemovedFileDescription :=
              Format(
                '"%s" (Ошибка %d)',
                [DocumentFile.FileName, e.ErrorCode]
              );
              
            if NotRemovedDocumentFileNameList = '' then
              NotRemovedDocumentFileNameList := NotRemovedFileDescription

            else
              NotRemovedDocumentFileNameList :=
                NotRemovedDocumentFileNameList +
                ', ' +
                NotRemovedFileDescription;

          end;

        end;

      end;

    end;

    if NotRemovedDocumentFileNameList <> '' then begin

      raise TDocumentFileStorageServiceException.Create(
        'Не удалось удалить следующие файлы ' +
        'из удаленного хранилища:' + sLineBreak +
        NotRemovedDocumentFileNameList
      );

    end;
    
  finally

    FFileStorageServiceClient.Disconnect;

  end;

end;

procedure TStandardDocumentFileStorageService.SetDocumentFilePathGenerator(
  Value: IDocumentFilePathGenerator);
begin

  FDocumentFilePathGenerator := Value;

end;

procedure TStandardDocumentFileStorageService.UpdateDocumentFilesFor(
  DocumentFiles: TDocumentFiles;
  const DocumentId: Variant
);
var CurrentDocumentFilesForDocument: TDocumentFiles;
    DocumentFile: TDocumentFile;
    MustBeDeletedDocumentFiles: TDocumentFiles;
    MustBeAddedDocumentFiles: TDocumentFiles;
begin

  CurrentDocumentFilesForDocument :=
    FDocumentFileMetadataDirectory.FindDocumentFileMetadatas(DocumentId);

  MustBeDeletedDocumentFiles := TDocumentFiles.Create;
  MustBeAddedDocumentFiles := TDocumentFiles.Create;

  try

    if Assigned(CurrentDocumentFilesForDocument) then
    begin

      for DocumentFile in CurrentDocumentFilesForDocument do begin

        if DocumentFiles.FindByIdentity(DocumentFile.Identity) = nil then
          MustBeDeletedDocumentFiles.AddDomainObject(
            DocumentFile.Clone as TDocumentFile
          );

      end;

    end;

    for DocumentFile in DocumentFiles do begin

      if VarIsNull(DocumentFile.Identity) then
        MustBeAddedDocumentFiles.AddDomainObject(
          DocumentFile.Clone as TDocumentFile
        )

    end;

    RemoveDocumentFiles(MustBeDeletedDocumentFiles);
    PutDocumentFiles(MustBeAddedDocumentFiles);

  finally

    FreeAndNil(MustBeDeletedDocumentFiles);
    FreeAndNil(MustBeAddedDocumentFiles);
    
  end;
    
end;

{ TStandardDocumentFilePathGenerator }

constructor TStandardDocumentFilePathGenerator.Create(
  DocumentType: TDocumentClass;
  PathBuilder: IPathBuilder
);
begin

  inherited Create;

  FDocumentType := DocumentType;
  FPathBuilder := PathBuilder;

end;

function TStandardDocumentFilePathGenerator.GeneratePathForDocumentFile(
  DocumentFile: TDocumentFile;
  const AdditionalPartOfPath: String
): String;
var

    CurrentDateTime: TDateTime;

    DocumentFileExt: String;
begin

  CurrentDateTime := Now;

  DocumentFileExt := ExtractFileExt(DocumentFile.FilePath);

  Result :=
    FPathBuilder
      .AddPartOfPath(GetDocumentTypePrefixFrom(FDocumentType))
      .AddPartOfPath(IntToStr(YearOf(CurrentDateTime)))
      .AddPartOfPath(IntToStr(MonthOf(CurrentDateTime)))
      .AddPartOfPath(IntToStr(DayOf(CurrentDateTime)))
      .AddPartOfPath(
        GetDocumentTypePrefixFrom(FDocumentType) + '_' +
        ReplaceStr(
          ReplaceStr(
            ReplaceStr(
              DateTimeToStr(CurrentDateTime),
              ':',
              '_'
            ),
            '.',
            '_'
          ),
          ' ',
          '_'
        ) + '_' + VarToStr(DocumentFile.DocumentId) + '_' +
        AdditionalPartOfPath + DocumentFileExt
      ).
      BuildPath;

end;

function TStandardDocumentFilePathGenerator.GetDocumentTypePrefixFrom(
  DocumentType: TDocumentClass): String;
begin

  if
    DocumentType.InheritsFrom(TServiceNote) or
    DocumentType.InheritsFrom(TInternalServiceNote) or
    DocumentType.InheritsFrom(TIncomingServiceNote) or
    DocumentType.InheritsFrom(TIncomingInternalServiceNote)
  then
    Result := 'sz'

  else if DocumentType.InheritsFrom(TPersonnelOrder) then
    Result := 'po'
    
  else begin

    raise TDocumentFilePathGeneratorException.CreateFmt(
      'Программная ошибка. Не удалось построить часть ' +
      'пути к файлу документа вида "%s"',
      [
        DocumentType.ClassName
      ]
    );

  end;
  
end;

end.
