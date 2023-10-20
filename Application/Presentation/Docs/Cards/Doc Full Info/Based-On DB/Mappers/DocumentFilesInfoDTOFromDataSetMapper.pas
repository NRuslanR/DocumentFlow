unit DocumentFilesInfoDTOFromDataSetMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentFilesInfoHolder,
  VariantListUnit,
  Disposable,
  SysUtils;

type

  TDocumentFilesInfoDTOFromDataSetMapper = class (TInterfacedObject, IDisposable)

    protected

      function MapDocumentFileInfoDTOFrom(DocumentFilesInfoHolder: TDocumentFilesInfoHolder): TDocumentFileInfoDTO;

    public

      function MapDocumentFilesInfoDTOFrom(DocumentFilesInfoHolder: TDocumentFilesInfoHolder): TDocumentFilesInfoDTO;
      
  end;

implementation

uses

  Variants;

{ TDocumentFilesInfoDTOFromDataSetMapper }


function TDocumentFilesInfoDTOFromDataSetMapper.MapDocumentFilesInfoDTOFrom(
  DocumentFilesInfoHolder: TDocumentFilesInfoHolder): TDocumentFilesInfoDTO;
var
    HandledDocumentFileIds: TVariantList;
    DocumentFileInfoDTO: TDocumentFileInfoDTO;
begin

  HandledDocumentFileIds := TVariantList.Create;

  try

    Result := TDocumentFilesInfoDTO.Create;

    try

      with DocumentFilesInfoHolder do begin

        First;

        while not Eof do begin

          if
              not VarIsNull(IdFieldValue) and
              not HandledDocumentFileIds.Contains(IdFieldValue)
              
          then begin

            DocumentFileInfoDTO := MapDocumentFileInfoDTOFrom(DocumentFilesInfoHolder);

            Result.Add(DocumentFileInfoDTO);

            HandledDocumentFileIds.Add(IdFieldValue);
          
          end;

          Next;

        end;

      end;

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(HandledDocumentFileIds);
    
  end;

end;

function TDocumentFilesInfoDTOFromDataSetMapper.MapDocumentFileInfoDTOFrom(
  DocumentFilesInfoHolder: TDocumentFilesInfoHolder): TDocumentFileInfoDTO;
begin

  Result := TDocumentFileInfoDTO.Create;

  try

    with DocumentFilesInfoHolder do begin

      Result.Id := IdFieldValue;
      Result.DocumentId := DocumentIdFieldValue;
      Result.FileName := NameFieldValue;
      Result.FilePath := PathFieldValue;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

end.
