unit StandardOriginalDocumentInfoReadService;

interface

uses

  OriginalDocumentInfoReadService,
  AbstractApplicationService,
  DocumentInfoReadService,
  DocumentFullInfoDTO,
  IncomingDocumentFullInfoDTO,
  SysUtils,
  Classes;

type

  TStandardOriginalDocumentInfoReadService =
    class (
      TAbstractApplicationService,
      IOriginalDocumentInfoReadService,
      IDocumentInfoReadService
    )

      private

        FDocumentInfoReadService: IDocumentInfoReadService;

        function ExtractOriginalDocumentFullInfoDTO(
          DocumentFullInfoDTO: TDocumentFullInfoDTO
        ): TDocumentFullInfoDTO;
        
      public

        constructor Create(DocumentInfoReadService: IDocumentInfoReadService);

        function GetDocumentFullInfo(const DocumentId: Variant): TDocumentFullInfoDTO;
        
    end;
  
implementation

uses

  Disposable;

{ TStandardOriginalDocumentInfoReadService }

constructor TStandardOriginalDocumentInfoReadService.Create(
  DocumentInfoReadService: IDocumentInfoReadService);
begin

  inherited Create;

  FDocumentInfoReadService := DocumentInfoReadService;
  
end;

function TStandardOriginalDocumentInfoReadService.GetDocumentFullInfo(
  const DocumentId: Variant): TDocumentFullInfoDTO;
var
    DocumentFullInfoDTO: TDocumentFullInfoDTO;
begin

  DocumentFullInfoDTO := FDocumentInfoReadService.GetDocumentFullInfo(DocumentId);

  Result := ExtractOriginalDocumentFullInfoDTO(DocumentFullInfoDTO);
  
end;

function TStandardOriginalDocumentInfoReadService
  .ExtractOriginalDocumentFullInfoDTO(
    DocumentFullInfoDTO: TDocumentFullInfoDTO
  ): TDocumentFullInfoDTO;
var
    IncomingDocumentFullInfoDTO: TIncomingDocumentFullInfoDTO;
    Free: IDisposable;
begin

  if not (DocumentFullInfoDTO is TIncomingDocumentFullInfoDTO) then
  begin

    Result := DocumentFullInfoDTO;
    Exit;

  end;

  IncomingDocumentFullInfoDTO := TIncomingDocumentFullInfoDTO(DocumentFullInfoDTO);

  Free := IncomingDocumentFullInfoDTO;
  
  Result := TDocumentFullInfoDTO.Create;

  with IncomingDocumentFullInfoDTO do begin

    Result.DocumentDTO := DocumentDTO.OriginalDocumentDTO;
    Result.DocumentRelationsInfoDTO := DocumentRelationsInfoDTO;
    Result.DocumentFilesInfoDTO := DocumentFilesInfoDTO;
    Result.DocumentApprovingCycleResultsInfoDTO := DocumentApprovingCycleResultsInfoDTO;
    Result.DocumentChargeSheetsInfoDTO := DocumentChargeSheetsInfoDTO;

  end;

end;

end.
