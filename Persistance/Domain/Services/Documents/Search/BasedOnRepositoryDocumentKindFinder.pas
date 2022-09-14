unit BasedOnRepositoryDocumentKindFinder;

interface

uses

  DocumentKind,
  VariantListUnit,
  AbstractDocumentKindFinder,
  Document,
  DocumentKindRepository,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentKindFinder = class (TAbstractDocumentKindFinder)

    private

      FDocumentKindRepository: IDocumentKindRepository;
      
    public

      constructor Create(DocumentKindRepository: IDocumentKindRepository);

      function LoadAllDocumentKinds: TDocumentKinds; override;
      function FindDocumentKindByIdentity(const DocumentKindIdentity: Variant): TDocumentKind; override;
      function FindDocumentKindsByIdentities(const Identities: TVariantList): TDocumentKinds; override;
      function FindDocumentKindByServiceName(const ServiceName: String): TDocumentKind; override;
      function FindDocumentKindByClassType(DocumentType: TDocumentClass): TDocumentKind; override;
    
  end;

implementation

{ TBasedOnRepositoryDocumentKindFinder }

constructor TBasedOnRepositoryDocumentKindFinder.Create(
  DocumentKindRepository: IDocumentKindRepository);
begin

  inherited Create;

  FDocumentKindRepository := DocumentKindRepository;
  
end;

function TBasedOnRepositoryDocumentKindFinder.FindDocumentKindByClassType(
  DocumentType: TDocumentClass): TDocumentKind;
begin

  Result := FDocumentKindRepository.FindDocumentKindByClassType(DocumentType);
  
end;

function TBasedOnRepositoryDocumentKindFinder.FindDocumentKindByIdentity(
  const DocumentKindIdentity: Variant
): TDocumentKind;
begin

  Result := FDocumentKindRepository.FindDocumentKindByIdentity(DocumentKindIdentity);

end;

function TBasedOnRepositoryDocumentKindFinder.FindDocumentKindByServiceName(
  const ServiceName: String): TDocumentKind;
begin

  Result := FDocumentKindRepository.FindDocumentKindByServiceName(ServiceName);
  
end;

function TBasedOnRepositoryDocumentKindFinder.FindDocumentKindsByIdentities(
  const Identities: TVariantList): TDocumentKinds;
begin

  Result := FDocumentKindRepository.FindDocumentKindsByIdentities(Identities);
  
end;

function TBasedOnRepositoryDocumentKindFinder.LoadAllDocumentKinds: TDocumentKinds;
begin

  Result := FDocumentKindRepository.LoadAllDocumentKinds;

end;

end.
