unit BasedOnRepositoryDocumentChargeKindsControlService;

interface

uses

  AbstractDocumentChargeKindsControlService,
  DocumentChargeKindRepository,
  DocumentChargeKind,
  DomainException,
  SysUtils;

type

  TBasedOnRepositoryDocumentChargeKindsControlService =
    class (TAbstractDocumentChargeKindsControlService)

      private

        FDocumentChargeKindRepository: IDocumentChargeKindRepository;
        
      protected

        function DoUpdateDocumentChargeKinds: TDocumentChargeKinds; override;
        
        function InternalFindAllowedDocumentChargeKindsForDocumentKind(
          const DocumentKindId: Variant
        ): TDocumentChargeKinds; override;
        
      public

        constructor Create(DocumentChargeKindRepository: IDocumentChargeKindRepository);
        
    end;
    
implementation

{ TBasedOnRepositoryDocumentChargeKindsControlService }

constructor TBasedOnRepositoryDocumentChargeKindsControlService.Create(
  DocumentChargeKindRepository: IDocumentChargeKindRepository);
begin

  inherited Create;

  FDocumentChargeKindRepository := DocumentChargeKindRepository;
  
end;

function TBasedOnRepositoryDocumentChargeKindsControlService.
  DoUpdateDocumentChargeKinds: TDocumentChargeKinds;
begin

  Result := FDocumentChargeKindRepository.FindAllDocumentChargeKinds;

end;

function TBasedOnRepositoryDocumentChargeKindsControlService
  .InternalFindAllowedDocumentChargeKindsForDocumentKind(
    const DocumentKindId: Variant
  ): TDocumentChargeKinds;
begin

  Result :=
    FDocumentChargeKindRepository.FindAllowedDocumentChargeKindsForDocumentKind(DocumentKindId);

end;

end.
