unit DocumentRelationsInfoDTOFromDataSetMapper;

interface

uses

  DocumentRelationsInfoHolder,
  Disposable,
  DocumentFullInfoDTO,
  SysUtils,
  Variants,
  VariantListUnit;

type

  TDocumentRelationsInfoDTOFromDataSetMapper = class (TInterfacedObject, IDisposable)

    protected

      function MapDocumentRelationInfoDTOFrom(DocumentRelationsInfoHolder: TDocumentRelationsInfoHolder): TDocumentRelationInfoDTO;

    public

      function MapDocumentRelationsInfoDTOFrom(DocumentRelationsInfoHolder: TDocumentRelationsInfoHolder): TDocumentRelationsInfoDTO;

  end;

implementation

{ TDocumentRelationsInfoDTOFromDataSetMapper }

function TDocumentRelationsInfoDTOFromDataSetMapper.MapDocumentRelationsInfoDTOFrom(
  DocumentRelationsInfoHolder: TDocumentRelationsInfoHolder
): TDocumentRelationsInfoDTO;
var HandledDocumentRelationIds: TVariantList;
    DocumentRelationInfoDTO: TDocumentRelationInfoDTO;
begin

  HandledDocumentRelationIds := TVariantList.Create;

  try

    Result := TDocumentRelationsInfoDTO.Create;

    try
      with DocumentRelationsInfoHolder do begin

        First;

        while not Eof do begin

          if

              not VarIsNull(DocumentRelationIdFieldValue) and
              not HandledDocumentRelationIds.Contains(
                    DocumentRelationIdFieldValue
                  )
                  
          then begin

            DocumentRelationInfoDTO :=
              MapDocumentRelationInfoDTOFrom(DocumentRelationsInfoHolder);

            Result.Add(DocumentRelationInfoDTO);

            HandledDocumentRelationIds.Add(DocumentRelationIdFieldValue);

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

    FreeAndNil(HandledDocumentRelationIds);

  end;

end;

function TDocumentRelationsInfoDTOFromDataSetMapper.MapDocumentRelationInfoDTOFrom(
  DocumentRelationsInfoHolder: TDocumentRelationsInfoHolder
): TDocumentRelationInfoDTO;
begin

  Result := TDocumentRelationInfoDTO.Create;

  try

    with DocumentRelationsInfoHolder do begin

      Result.TargetDocumentId := TargetDocumentIdFieldValue;
      Result.RelatedDocumentId := RelatedDocumentIdFieldValue;
      Result.RelatedDocumentKindId := RelatedDocumentKindIdFieldValue;
      Result.RelatedDocumentKindName := RelatedDocumentKindNameFieldValue;
      Result.RelatedDocumentNumber := RelatedDocumentNumberFieldValue;
      Result.RelatedDocumentName := RelatedDocumentNameFieldValue;
      Result.RelatedDocumentDate := RelatedDocumentDateFieldValue;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

end.
