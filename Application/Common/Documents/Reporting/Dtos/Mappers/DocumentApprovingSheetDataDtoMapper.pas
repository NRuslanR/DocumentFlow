unit DocumentApprovingSheetDataDtoMapper;

interface

uses

  DocumentApprovingSheetData,
  DocumentApprovingSheetDataDto,
  DocumentDTOMapper,
  Document,
  DocumentApprovingsInfoDTOMapper,
  Disposable,
  SysUtils;

type

  IDocumentApprovingSheetDataDtoMapper = interface

    function MapDocumentApprovingSheetDataDtoFrom(
      DocumentApprovingSheetData: TDocumentApprovingSheetData
    ): TDocumentApprovingSheetDataDto;

  end;

  TDocumentApprovingSheetDataDtoMapper =
    class (TInterfacedObject, IDocumentApprovingSheetDataDtoMapper)

      protected

        FDocumentDtoMapper: TDocumentDTOMapper;
        FDocumentApprovingsInfoDtoMapper: TDocumentApprovingsInfoDTOMapper;

        FFreeDocumentDtoMapper: IDisposable;
        FFreeDocumentApprovingsInfoDtoMapper: IDisposable;

      protected

        function CreateDocumentApprovingSheetDataDtoInstance: TDocumentApprovingSheetDataDto; virtual;

        procedure FillDocumentApprovingSheetDataDto(
          DocumentApprovingSheetDataDto: TDocumentApprovingSheetDataDto;
          DocumentApprovingSheetData: TDocumentApprovingSheetData
        ); virtual;

      public

        destructor Destroy; override;

        constructor Create(
          DocumentDtoMapper: TDocumentDTOMapper;
          DocumentApprovingsInfoDtoMapper: TDocumentApprovingsInfoDTOMapper
        );

        function MapDocumentApprovingSheetDataDtoFrom(
          DocumentApprovingSheetData: TDocumentApprovingSheetData
        ): TDocumentApprovingSheetDataDto; virtual;

    end;

implementation

{ TDocumentApprovingSheetDataDtoMapper }

constructor TDocumentApprovingSheetDataDtoMapper.Create(
  DocumentDtoMapper: TDocumentDTOMapper;
  DocumentApprovingsInfoDtoMapper: TDocumentApprovingsInfoDTOMapper
);
begin

  inherited Create;

  FDocumentDtoMapper := DocumentDtoMapper;
  FDocumentApprovingsInfoDtoMapper := DocumentApprovingsInfoDtoMapper;

  FFreeDocumentDtoMapper := FDocumentDtoMapper;
  FFreeDocumentApprovingsInfoDtoMapper := FDocumentApprovingsInfoDtoMapper;
  
end;

function TDocumentApprovingSheetDataDtoMapper.
  CreateDocumentApprovingSheetDataDtoInstance: TDocumentApprovingSheetDataDto;
begin

  Result := TDocumentApprovingSheetDataDto.Create;

end;

destructor TDocumentApprovingSheetDataDtoMapper.Destroy;
begin

  inherited;

end;

procedure TDocumentApprovingSheetDataDtoMapper.FillDocumentApprovingSheetDataDto(
  DocumentApprovingSheetDataDto: TDocumentApprovingSheetDataDto;
  DocumentApprovingSheetData: TDocumentApprovingSheetData);
begin

  DocumentApprovingSheetDataDto.DocumentDto :=
    FDocumentDtoMapper.MapDocumentDTOFrom(
      TDocument(DocumentApprovingSheetData.Document.Self),
      DocumentApprovingSheetData.Document.Author
    );

  DocumentApprovingSheetDataDto.DocumentApprovingsDto :=
    FDocumentApprovingsInfoDtoMapper.MapDocumentApprovingsInfoDTOFrom(
      DocumentApprovingSheetData.DocumentApprovings
    );

end;

function TDocumentApprovingSheetDataDtoMapper.MapDocumentApprovingSheetDataDtoFrom(
  DocumentApprovingSheetData: TDocumentApprovingSheetData): TDocumentApprovingSheetDataDto;
begin

  Result := CreateDocumentApprovingSheetDataDtoInstance;

  try

    FillDocumentApprovingSheetDataDto(Result, DocumentApprovingSheetData);
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
