unit DocumentFilesFormViewModelMapper;

interface

uses

  DocumentFileSetHolder,
  DocumentFilesFormViewModelUnit,
  DocumentFullInfoDTO,
  DocumentFileSetHolderFactory,
  SysUtils,
  Classes,
  DB;

type

  TDocumentFilesFormViewModelMapper = class

    protected

      FDocumentFileSetHolderFactory: IDocumentFileSetHolderFactory;
      
      function CreateDocumentFilesFormViewModelInstance:
        TDocumentFilesFormViewModel; virtual;
        
    public

      constructor Create(DocumentFileSetHolderFactory: IDocumentFileSetHolderFactory);

      function MapDocumentFilesFormViewModelFrom(
        DocumentFilesInfoDTO: TDocumentFilesInfoDTO
      ): TDocumentFilesFormViewModel; virtual;

      function MapDocumentFilesFormViewModelTo(
        DocumentFilesFormViewModel: TDocumentFilesFormViewModel
      ): TDocumentFilesInfoDTO; virtual;

      function CreateEmptyDocumentFilesFormViewModel: TDocumentFilesFormViewModel; virtual;


  end;
  
implementation

uses

  AuxDebugFunctionsUnit,
  AbstractDataSetHolder;

{ TDocumentFilesFormViewModelMapper }

constructor TDocumentFilesFormViewModelMapper.Create(
  DocumentFileSetHolderFactory: IDocumentFileSetHolderFactory);
begin

  inherited Create;

  FDocumentFileSetHolderFactory := DocumentFileSetHolderFactory;
  
end;

function TDocumentFilesFormViewModelMapper.
  CreateDocumentFilesFormViewModelInstance: TDocumentFilesFormViewModel;
begin

  Result := TDocumentFilesFormViewModel.Create;
  
end;

function TDocumentFilesFormViewModelMapper.
  CreateEmptyDocumentFilesFormViewModel: TDocumentFilesFormViewModel;
begin

  Result := CreateDocumentFilesFormViewModelInstance;

  Result.DocumentFileSetHolder := FDocumentFileSetHolderFactory.CreateDocumentFileSetHolder;
    
end;

function TDocumentFilesFormViewModelMapper.
  MapDocumentFilesFormViewModelFrom(
    DocumentFilesInfoDTO: TDocumentFilesInfoDTO
  ): TDocumentFilesFormViewModel;
var
    DocumentFileInfoDTO: TDocumentFileInfoDTO;
begin

  Result := CreateEmptyDocumentFilesFormViewModel;

  if not Assigned(DocumentFilesInfoDTO) then Exit;

  try

    for DocumentFileInfoDTO in DocumentFilesInfoDTO do begin

      with Result.DocumentFileSetHolder do begin

        AppendWithoutRecordIdGeneration;

        IdFieldValue := DocumentFileInfoDTO.Id;
        FileNameFieldValue := DocumentFileInfoDTO.FileName;
        FilePathFieldValue := DocumentFileInfoDTO.FilePath;

        MarkCurrentRecordAsNonChanged;
		
		    Post;
        
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentFilesFormViewModelMapper.
  MapDocumentFilesFormViewModelTo(
    DocumentFilesFormViewModel: TDocumentFilesFormViewModel
  ): TDocumentFilesInfoDTO;
var
    DocumentFileInfoDTO: TDocumentFileInfoDTO;
    DocumentFileSetHolder: TDocumentFileSetHolder;
begin

  DocumentFileSetHolder :=
    DocumentFilesFormViewModel.DocumentFileSetHolder;

  Result := TDocumentFilesInfoDTO.Create;

  try

    DocumentFileSetHolder.First;

    while not DocumentFileSetHolder.Eof do
    begin

      DocumentFileInfoDTO := TDocumentFileInfoDTO.Create;

      Result.Add(DocumentFileInfoDTO);
      
      DocumentFileInfoDTO.Id := DocumentFileSetHolder.IdFieldValue;

      DocumentFileInfoDTO.FileName := DocumentFileSetHolder.FileNameFieldValue;

      DocumentFileInfoDTO.FilePath := DocumentFileSetHolder.FilePathFieldValue;

      DocumentFileSetHolder.Next;

    end;
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
