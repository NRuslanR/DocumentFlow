unit IncomingDocumentDTOFromDataSetMapper;

interface

uses

  DocumentInfoHolder,
  DocumentFullInfoDTO,
  IncomingDocumentFullInfoDTO,
  IncomingDocumentInfoHolder,
  Disposable,
  DocumentDTOFromDataSetMapper,
  SysUtils;

type

  TIncomingDocumentDTOFromDataSetMapper =
    class (TDocumentDTOFromDataSetMapper)

      protected

        FDocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper;
        FFreeDocumentDTOFromDataSetMapper: IDisposable;

      protected

        function CreateIncomingDocumentDTOInstance: TIncomingDocumentDTO; virtual;
        
        procedure FillIncomingDocumentDTOFrom(
          IncomingDocumentDTO: TIncomingDocumentDTO;
          IncomingDocumentInfoHolder: TIncomingDocumentInfoHolder
        ); virtual;
        
      public

        constructor Create(DocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper);
        
        function MapDocumentDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentDTO; override;

    end;

implementation

uses

  DB,
  AuxDebugFunctionsUnit;
  
{ TIncomingDocumentDTOFromDataSetMapper }

constructor TIncomingDocumentDTOFromDataSetMapper.Create(
  DocumentDTOFromDataSetMapper: TDocumentDTOFromDataSetMapper);
begin

  inherited Create;

  FDocumentDTOFromDataSetMapper := DocumentDTOFromDataSetMapper;
  FFreeDocumentDTOFromDataSetMapper := FDocumentDTOFromDataSetMapper;
  
end;

function TIncomingDocumentDTOFromDataSetMapper.MapDocumentDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentDTO;
var
    OriginalDocumentDTO: TDocumentDTO;
    IncomingDocumentInfoHolder: TIncomingDocumentInfoHolder;
    OriginalDocumentInfoHolder: TDocumentInfoHolder;
begin

  IncomingDocumentInfoHolder := DocumentInfoHolder as TIncomingDocumentInfoHolder;
  OriginalDocumentInfoHolder := IncomingDocumentInfoHolder.OriginalDocumentInfoHolder;
  
  Result := CreateIncomingDocumentDTOInstance;

  try

    with TIncomingDocumentDTO(Result) do begin

      OriginalDocumentDTO :=
        FDocumentDTOFromDataSetMapper
          .MapDocumentDTOFrom(OriginalDocumentInfoHolder);

      FillIncomingDocumentDTOFrom(
        TIncomingDocumentDTO(Result),
        IncomingDocumentInfoHolder
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TIncomingDocumentDTOFromDataSetMapper.FillIncomingDocumentDTOFrom(
  IncomingDocumentDTO: TIncomingDocumentDTO;
  IncomingDocumentInfoHolder: TIncomingDocumentInfoHolder
);
begin

  with IncomingDocumentDTO, IncomingDocumentInfoHolder do begin

    Id := IncomingDocumentIdFieldValue;
    KindId := IncomingDocumentKindIdFieldValue;
    Kind := IncomingDocumentKindNameFieldValue;
    IncomingNumber := IncomingNumberFieldValue;
    IncomingNumberPartsSeparator := '/'; { refactor }
    ReceiptDate := ReceiptDateFieldValue;
    CurrentWorkCycleStageNumber := IncomingDocumentStageNumberFieldValue;
    CurrentWorkCycleStageName := IncomingDocumentStageNameFieldValue;

  end;

end;

function TIncomingDocumentDTOFromDataSetMapper.
  CreateIncomingDocumentDTOInstance: TIncomingDocumentDTO;
begin

  Result := TIncomingDocumentDTO.Create;
  
end;


end.
