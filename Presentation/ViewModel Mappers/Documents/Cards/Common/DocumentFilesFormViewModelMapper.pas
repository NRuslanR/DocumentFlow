unit DocumentFilesFormViewModelMapper;

interface

uses

  DocumentFileSetHolder,
  DocumentFilesFormViewModelUnit,
  DocumentFullInfoDTO,
  SysUtils,
  Classes,
  DB;

type

  TDocumentFilesFormViewModelMapper = class

    protected

      function CreateDocumentFilesFormViewModelInstance:
        TDocumentFilesFormViewModel; virtual;
        
    public

      function MapDocumentFilesFormViewModelFrom(
        DocumentFilesInfoDTO: TDocumentFilesInfoDTO;
        DocumentFileSetHolder: TDocumentFileSetHolder
      ): TDocumentFilesFormViewModel; virtual;

      function MapDocumentFilesFormViewModelTo(
        DocumentFilesFormViewModel: TDocumentFilesFormViewModel
      ): TDocumentFilesInfoDTO; virtual;

      function CreateEmptyDocumentFilesFormViewModel(
        DocumentFileSetHolder: TDocumentFileSetHolder
      ): TDocumentFilesFormViewModel; virtual;


  end;
  
implementation

uses AbstractDataSetHolder;

{ TDocumentFilesFormViewModelMapper }

function TDocumentFilesFormViewModelMapper.
  CreateDocumentFilesFormViewModelInstance: TDocumentFilesFormViewModel;
begin

  Result := TDocumentFilesFormViewModel.Create;
  
end;

function TDocumentFilesFormViewModelMapper.
  CreateEmptyDocumentFilesFormViewModel(
    DocumentFileSetHolder: TDocumentFileSetHolder
  ): TDocumentFilesFormViewModel;
begin

  Result := CreateDocumentFilesFormViewModelInstance;

  Result.DocumentFileSetHolder :=
    DocumentFileSetHolder;
    
end;

function TDocumentFilesFormViewModelMapper.
  MapDocumentFilesFormViewModelFrom(
    DocumentFilesInfoDTO: TDocumentFilesInfoDTO;
    DocumentFileSetHolder: TDocumentFileSetHolder
  ): TDocumentFilesFormViewModel;
var DocumentFileInfoDTO: TDocumentFileInfoDTO;
begin

  Result := CreateDocumentFilesFormViewModelInstance;

  if Assigned(DocumentFilesInfoDTO) then begin

    for DocumentFileInfoDTO in DocumentFilesInfoDTO do begin

      DocumentFileSetHolder.Append;

      with DocumentFileSetHolder do begin

        IdFieldValue := DocumentFileInfoDTO.Id;
        FileNameFieldValue := DocumentFileInfoDTO.FileName;
        FilePathFieldValue := DocumentFileInfoDTO.FilePath;

        MarkCurrentRecordAsNonChanged;

      end;

      DocumentFileSetHolder.Post;

    end;

  end;

  Result.DocumentFileSetHolder := DocumentFileSetHolder;

end;

function TDocumentFilesFormViewModelMapper.
  MapDocumentFilesFormViewModelTo(
    DocumentFilesFormViewModel: TDocumentFilesFormViewModel
  ): TDocumentFilesInfoDTO;
var DocumentFileInfoDTO: TDocumentFileInfoDTO;
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

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

end.
