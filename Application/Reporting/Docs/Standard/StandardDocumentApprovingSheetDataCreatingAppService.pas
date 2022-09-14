unit StandardDocumentApprovingSheetDataCreatingAppService;

interface

uses

  DocumentApprovingSheetDataCreatingAppService,
  AbstractApplicationService,
  DocumentApprovingSheetDataDtoMapper,
  DocumentApprovingSheetDataDto,
  DocumentApprovingSheetDataCreatingService,
  DocumentApprovingSheetData,
  SysUtils;

type

  TStandardDocumentApprovingSheetDataCreatingAppService =
    class (TAbstractApplicationService, IDocumentApprovingSheetDataCreatingAppService)

      protected

         FDocumentApprovingSheetDataCreatingService: IDocumentApprovingSheetDataCreatingService;
         FDocumentApprovingSheetDataDtoMapper: TDocumentApprovingSheetDataDtoMapper;

      public

        constructor Create(
          DocumentApprovingSheetDataCreatingService: IDocumentApprovingSheetDataCreatingService;
          DocumentApprovingSheetDataDtoMapper: TDocumentApprovingSheetDataDtoMapper
        );
        
        function CreateDocumentApprovingSheetData(const DocumentId: Variant): TDocumentApprovingSheetDataDto;
      
    end;

implementation

uses

  IDomainObjectBaseUnit;

{ TStandardDocumentApprovingSheetDataCreatingAppService }

constructor TStandardDocumentApprovingSheetDataCreatingAppService.Create(
  DocumentApprovingSheetDataCreatingService: IDocumentApprovingSheetDataCreatingService;
  DocumentApprovingSheetDataDtoMapper: TDocumentApprovingSheetDataDtoMapper);
begin

  inherited Create;

  FDocumentApprovingSheetDataCreatingService := DocumentApprovingSheetDataCreatingService;
  FDocumentApprovingSheetDataDtoMapper := DocumentApprovingSheetDataDtoMapper;
  
end;

function TStandardDocumentApprovingSheetDataCreatingAppService.CreateDocumentApprovingSheetData(
  const DocumentId: Variant
): TDocumentApprovingSheetDataDto;
var
    DocumentApprovingSheetData: TDocumentApprovingSheetData;
    Free: IDomainObjectBase;
begin

  DocumentApprovingSheetData :=
    FDocumentApprovingSheetDataCreatingService.CreateDocumentApprovingSheet(
      DocumentId
    );

  if not Assigned(DocumentApprovingSheetData) then begin

    Result := nil;
    Exit;

  end

  else begin

    Free := DocumentApprovingSheetData;

    Result :=
      FDocumentApprovingSheetDataDtoMapper.MapDocumentApprovingSheetDataDtoFrom(
        DocumentApprovingSheetData
      );

  end;

end;

end.
