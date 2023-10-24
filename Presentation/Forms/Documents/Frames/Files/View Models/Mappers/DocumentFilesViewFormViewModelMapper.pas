unit DocumentFilesViewFormViewModelMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentFilesViewFormViewModel,
  DocumentFileInfoList,
  SysUtils,
  Classes;

type

  TDocumentFilesViewFormViewModelMapper = class

    protected

      function CreateDocumentFilesViewFormViewModelInstance:
        TDocumentFilesViewFormViewModel; virtual;
        
    public

      function MapDocumentFilesViewFormViewModelFrom(
        DocumentFilesInfoDTO: TDocumentFilesInfoDTO
      ): TDocumentFilesViewFormViewModel; virtual;

      function CreateEmptyDocumentFilesViewFormViewModel:
        TDocumentFilesViewFormViewModel; virtual;
      
  end;
  

implementation

{ TDocumentFilesViewFormViewModelMapper }

function TDocumentFilesViewFormViewModelMapper
  .CreateDocumentFilesViewFormViewModelInstance: TDocumentFilesViewFormViewModel;
begin

  Result := TDocumentFilesViewFormViewModel.Create;
  
end;

function TDocumentFilesViewFormViewModelMapper
  .CreateEmptyDocumentFilesViewFormViewModel: TDocumentFilesViewFormViewModel;
begin

  Result := CreateDocumentFilesViewFormViewModelInstance;

  Result.DocumentFileInfoList := TDocumentFileInfoList.Create;
  
end;

function TDocumentFilesViewFormViewModelMapper.
  MapDocumentFilesViewFormViewModelFrom(
    DocumentFilesInfoDTO: TDocumentFilesInfoDTO
  ): TDocumentFilesViewFormViewModel;
var
    DocumentFileInfoList: TDocumentFileInfoList;
    DocumentFileInfoDTO: TDocumentFileInfoDTO;
    DocumentFileInfo: TDocumentFileInfo;
begin

  Result := CreateDocumentFilesViewFormViewModelInstance;

  try

    DocumentFileInfoList := TDocumentFileInfoList.Create;

    Result.DocumentFileInfoList := DocumentFileInfoList;

    if Assigned(DocumentFilesInfoDTO) then begin

      for DocumentFileInfoDTO in DocumentFilesInfoDTO do begin

        DocumentFileInfo :=
          TDocumentFileInfo.Create(
            DocumentFileInfoDTO.Id,
            DocumentFileInfoDTO.FileName,
            DocumentFileInfoDTO.FilePath
          );

        DocumentFileInfoList.Add(DocumentFileInfo);

      end;

    end;
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
