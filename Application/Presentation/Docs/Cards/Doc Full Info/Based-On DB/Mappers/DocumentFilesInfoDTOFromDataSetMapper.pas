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
              not VarIsNull(DocumentFileIdFieldValue) and
              not HandledDocumentFileIds.Contains(DocumentFileIdFieldValue)
              
          then begin

            DocumentFileInfoDTO := MapDocumentFileInfoDTOFrom(DocumentFilesInfoHolder);

            Result.Add(DocumentFileInfoDTO);

            HandledDocumentFileIds.Add(DocumentFileIdFieldValue);
          
          end;

          Next;

        end;

      end;

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;
        
      end;

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

      Result.Id := DocumentFileIdFieldValue;
      Result.DocumentId := DocumentIdFieldValue;
      Result.FileName := DocumentFileNameFieldValue;
      Result.FilePath := DocumentFilePathFieldValue;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;
  
end;

end.
