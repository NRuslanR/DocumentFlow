unit DocumentApprovingSheetDataDto;

interface

uses

  DocumentFullInfoDTO,
  SysUtils;

type

  TDocumentApprovingSheetDataDto = class

    public

      DocumentDto: TDocumentDTO;
      DocumentApprovingsDto: TDocumentApprovingsInfoDTO;

      destructor Destroy; override;

      constructor Create; overload;
      constructor Create(
        DocumentDto: TDocumentDTO;
        DocumentApprovingsDto: TDocumentApprovingsInfoDTO
      ); overload;

  end;

implementation

{ TDocumentApprovingSheetDataDto }

constructor TDocumentApprovingSheetDataDto.Create;
begin

end;

constructor TDocumentApprovingSheetDataDto.Create(
  DocumentDto: TDocumentDTO;
  DocumentApprovingsDto: TDocumentApprovingsInfoDTO
);
begin

  inherited Create;

  Self.DocumentDto := DocumentDto;
  Self.DocumentApprovingsDto := DocumentApprovingsDto;

end;

destructor TDocumentApprovingSheetDataDto.Destroy;
begin

  FreeAndNil(DocumentDto);
  FreeAndNil(DocumentApprovingsDto);
  
  inherited;

end;

end.
