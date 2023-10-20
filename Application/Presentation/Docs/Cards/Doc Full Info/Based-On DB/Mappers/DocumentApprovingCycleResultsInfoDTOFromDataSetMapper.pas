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

        if VarIsNull(IdFieldValue) or
           VarIsNull(CycleNumberFieldValue) or
           HandledDocumentApprovingIds.Contains(IdFieldValue)
        then begin

          Next;
          Continue;

        end;

        begin

          DocumentApprovingCycleResultInfoDTO :=
            Result.FindByCycleNumber(CycleNumberFieldValue);

          if not Assigned(DocumentApprovingCycleResultInfoDTO) then begin

            DocumentApprovingCycleResultInfoDTO := CreateDocumentApprovingCycleResultInfoDTOInstance;

            Result.Add(DocumentApprovingCycleResultInfoDTO);
            
            DocumentApprovingsInfoDTO :=
              FDocumentApprovingsInfoDTOFromDataSetMapper
                .CreateDocumentApprovingsInfoDTOInstance;

            DocumentApprovingCycleResultInfoDTO.DocumentApprovingsInfoDTO :=
              DocumentApprovingsInfoDTO;

            DocumentApprovingCycleResultInfoDTO.Id :=
              CycleIdFieldValue;

            DocumentApprovingCycleResultInfoDTO.CycleNumber :=
              CycleNumberFieldValue;

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

        HandledDocumentApprovingIds.Add(IdFieldValue);
        
        Next;
        
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
