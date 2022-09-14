unit StandardDocumentChargeKindsControlAppService;

interface

uses

  AbstractApplicationService,
  DocumentChargeKindsControlService,
  DocumentChargeKindsControlAppService,
  DocumentChargeKindDtoDomainMapper,
  DocumentChargeKindDto,
  DocumentChargeKind,
  SysUtils;

type

  TStandardDocumentChargeKindsControlAppService =
    class (TAbstractApplicationService, IDocumentChargeKindsControlAppService)

      private

        FDocumentChargeKindsControlService: IDocumentChargeKindsControlService;
        FDocumentChargeKindDtoDomainMapper: TDocumentChargeKindDtoDomainMapper;
        
      public

        constructor Create(
          DocumentChargeKindsControlService: IDocumentChargeKindsControlService;
          DocumentChargeKindDtoDomainMapper: TDocumentChargeKindDtoDomainMapper
        );
        
        function FindMainDocumentChargeKindForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKindDto;
        function FindAllowedDocumentChargeKindsForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKindDtos;

    end;
    
implementation

uses

  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;

{ TStandardDocumentChargeKindsControlAppService }

constructor TStandardDocumentChargeKindsControlAppService.Create(
  DocumentChargeKindsControlService: IDocumentChargeKindsControlService;
  DocumentChargeKindDtoDomainMapper: TDocumentChargeKindDtoDomainMapper
);
begin

  inherited Create;

  FDocumentChargeKindsControlService := DocumentChargeKindsControlService;
  FDocumentChargeKindDtoDomainMapper := DocumentChargeKindDtoDomainMapper;
  
end;

function TStandardDocumentChargeKindsControlAppService.FindAllowedDocumentChargeKindsForDocumentKind(
  const DocumentKindId: Variant): TDocumentChargeKindDtos;
var
    DocumentChargeKinds: TDocumentChargeKinds;
    Free: IDomainObjectBaseList;
begin

  DocumentChargeKinds := FDocumentChargeKindsControlService.FindAllowedDocumentChargeKindsForDocumentKind(DocumentKindId);

  Free := DocumentChargeKinds;

  Result := FDocumentChargeKindDtoDomainMapper.MapDocumentChargeKindDtos(DocumentChargeKinds);

end;

function TStandardDocumentChargeKindsControlAppService.FindMainDocumentChargeKindForDocumentKind(
  const DocumentKindId: Variant): TDocumentChargeKindDto;
var
    DocumentChargeKind: TDocumentChargeKind;
    Free: IDomainObjectBase;
begin

  DocumentChargeKind := FDocumentChargeKindsControlService.FindMainDocumentChargeKindForDocumentKind(DocumentKindId);

  Free := DocumentChargeKind;

  Result := FDocumentChargeKindDtoDomainMapper.MapDocumentChargeKindDto(DocumentChargeKind);
  
end;

end.
