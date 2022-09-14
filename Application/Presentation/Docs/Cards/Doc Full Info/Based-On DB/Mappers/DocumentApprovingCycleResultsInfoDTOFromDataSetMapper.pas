unit DocumentApprovingCycleResultsInfoDTOFromDataSetMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentApprovingsInfoHolder,
  DocumentApprovingsInfoDTOFromDataSetMapper,
  Disposable,
  VariantListUnit,
  SysUtils;

type

  TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper =
    class (TInterfacedObject, IDisposable)

      protected

        FDocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper;
        FFreeDocumentApprovingsInfoDTOFromDataSetMapper: IDisposable;
        
      protected

        function CreateDocumentApprovingCycleResultsInfoDTOInstance: TDocumentApprovingCycleResultsInfoDTO; virtual;
        function CreateDocumentApprovingCycleResultInfoDTOInstance: TDocumentApprovingCycleResultInfoDTO; virtual;
        
      public

        constructor Create(
          DocumentApprovingsInfoDTOFromDataSetMapper:
            TDocumentApprovingsInfoDTOFromDataSetMapper
        );
        
        function MapDocumentApprovingCycleResultsInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentApprovingCycleResultsInfoDTO;

    end;
    
implementation

uses

  Variants;
  
{ TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper }

constructor TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper.Create(
  DocumentApprovingsInfoDTOFromDataSetMapper: TDocumentApprovingsInfoDTOFromDataSetMapper);
begin

  inherited Create;

  FDocumentApprovingsInfoDTOFromDataSetMapper :=
    DocumentApprovingsInfoDTOFromDataSetMapper;

  FFreeDocumentApprovingsInfoDTOFromDataSetMapper :=
    FDocumentApprovingsInfoDTOFromDataSetMapper;
    
end;

function TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper
  .CreateDocumentApprovingCycleResultInfoDTOInstance: TDocumentApprovingCycleResultInfoDTO;
begin

  Result := TDocumentApprovingCycleResultInfoDTO.Create;

end;

function TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper
  .CreateDocumentApprovingCycleResultsInfoDTOInstance: TDocumentApprovingCycleResultsInfoDTO;
begin

  Result := TDocumentApprovingCycleResultsInfoDTO.Create;

end;

function TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper.
  MapDocumentApprovingCycleResultsInfoDTOFrom(
    DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
  ): TDocumentApprovingCycleResultsInfoDTO;

var
    DocumentApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO;
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO;
    HandledDocumentApprovingIds: TVariantList;
begin

  Result := CreateDocumentApprovingCycleResultsInfoDTOInstance;

  HandledDocumentApprovingIds := TVariantList.Create;
  
  try
    
    with DocumentApprovingsInfoHolder do begin

      First;

      while not Eof do begin

        if VarIsNull(DocumentApprovingIdFieldValue) or
           VarIsNull(DocumentApprovingCycleNumberFieldValue) or
           HandledDocumentApprovingIds.Contains(DocumentApprovingIdFieldValue)
        then begin

          Next;
          Continue;

        end;

        begin

          DocumentApprovingCycleResultInfoDTO :=
            Result.FindByCycleNumber(DocumentApprovingCycleNumberFieldValue);

          if not Assigned(DocumentApprovingCycleResultInfoDTO) then begin

            DocumentApprovingCycleResultInfoDTO := CreateDocumentApprovingCycleResultInfoDTOInstance;

            Result.Add(DocumentApprovingCycleResultInfoDTO);
            
            DocumentApprovingsInfoDTO :=
              FDocumentApprovingsInfoDTOFromDataSetMapper
                .CreateDocumentApprovingsInfoDTOInstance;

            DocumentApprovingCycleResultInfoDTO.DocumentApprovingsInfoDTO :=
              DocumentApprovingsInfoDTO;

            DocumentApprovingCycleResultInfoDTO.Id :=
              DocumentApprovingCycleIdFieldValue;
              
            DocumentApprovingCycleResultInfoDTO.CycleNumber :=
              DocumentApprovingCycleNumberFieldValue;

          end

          else
            DocumentApprovingsInfoDTO :=
              DocumentApprovingCycleResultInfoDTO.DocumentApprovingsInfoDTO;

        end;

        DocumentApprovingsInfoDTO.Add(
          FDocumentApprovingsInfoDTOFromDataSetMapper
            .MapDocumentApprovingInfoDTOFrom(
              DocumentApprovingsInfoHolder
            )
        );

        HandledDocumentApprovingIds.Add(DocumentApprovingIdFieldValue);
        
        Next;
        
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
