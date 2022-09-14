unit AbstractDocumentChargeKindsControlService;

interface

uses

  DocumentChargeKindsControlService,
  Document,
  DocumentChargeKind,
  DomainException,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  SysUtils;

type

  TAbstractDocumentChargeKindsControlService =
    class (TInterfacedObject, IDocumentChargeKindsControlService)

      protected

        FAreChargeKindsChanged: Boolean;
        
        FDocumentChargeKinds: TDocumentChargeKinds;
        FFreeDocumentChargeKinds: IDomainObjectBaseList;

        FDocumentKindChargeKindAllowings: TDocumentKindChargeKindAllowings;

        procedure UpdateDocumentChargeKindsIfNeccessary;
        function DoUpdateDocumentChargeKinds: TDocumentChargeKinds; virtual; abstract;

        function InternalFindAllowedDocumentChargeKindsForDocumentKind(
          const DocumentKindId: Variant
        ): TDocumentChargeKinds; virtual; abstract;

      public

        destructor Destroy; override;
        constructor Create;

        function GetAllDocumentChargeKinds: TDocumentChargeKinds;
        function FindDocumentChargeKindById(const ChargeKindId: Variant): TDocumentChargeKind;
        function FindMainDocumentChargeKindForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKind;
        function FindAllowedDocumentChargeKindsForDocument(Document: TDocument): TDocumentChargeKinds;
        function FindAllowedDocumentChargeKindsForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKinds;
        
    end;

implementation

uses

  ServiceNote,
  PersonnelOrder;
  
{ TAbstractDocumentChargeKindsControlService }

constructor TAbstractDocumentChargeKindsControlService.Create;
begin

  inherited;

  FAreChargeKindsChanged := True;

  FDocumentKindChargeKindAllowings := TDocumentKindChargeKindAllowings.Create;
  
end;

destructor TAbstractDocumentChargeKindsControlService.Destroy;
begin

  FreeAndNil(FDocumentKindChargeKindAllowings);

  inherited;

end;

function TAbstractDocumentChargeKindsControlService.FindAllowedDocumentChargeKindsForDocument(
  Document: TDocument): TDocumentChargeKinds;
begin

  Result := FindAllowedDocumentChargeKindsForDocumentKind(Document.KindIdentity);

end;

function TAbstractDocumentChargeKindsControlService.FindMainDocumentChargeKindForDocumentKind(
  const DocumentKindId: Variant): TDocumentChargeKind;
var
    ChargeKinds: TDocumentChargeKinds;
    Free: IDomainObjectBaseList;
begin

  ChargeKinds := FindAllowedDocumentChargeKindsForDocumentKind(DocumentKindId);

  if Assigned(ChargeKinds) then begin

    Free := ChargeKinds;

    Result := ChargeKinds.First;

  end

  else Result := nil;
  
end;

function TAbstractDocumentChargeKindsControlService.FindAllowedDocumentChargeKindsForDocumentKind(
  const DocumentKindId: Variant): TDocumentChargeKinds;
begin

  Result :=
    FDocumentKindChargeKindAllowings
      .FindAllowedDocumentChargeKindsForDocument(DocumentKindId);

  if not Assigned(Result) then begin

    Result := InternalFindAllowedDocumentChargeKindsForDocumentKind(DocumentKindId);

    FDocumentKindChargeKindAllowings.AddDocumentKindChargeKindAllowing(
      DocumentKindId, Result
    );
    
  end;

end;

function TAbstractDocumentChargeKindsControlService.FindDocumentChargeKindById(
  const ChargeKindId: Variant): TDocumentChargeKind;
begin

  UpdateDocumentChargeKindsIfNeccessary;

  Result := FDocumentChargeKinds.FindByIdentity(ChargeKindId);

end;

function TAbstractDocumentChargeKindsControlService.GetAllDocumentChargeKinds: TDocumentChargeKinds;
begin

  UpdateDocumentChargeKindsIfNeccessary;

  Result := FDocumentChargeKinds;
  
end;

procedure TAbstractDocumentChargeKindsControlService.UpdateDocumentChargeKindsIfNeccessary;
begin

  if FAreChargeKindsChanged then begin

    FDocumentChargeKinds := DoUpdateDocumentChargeKinds;
    FFreeDocumentChargeKinds := FDocumentChargeKinds;
    
    FAreChargeKindsChanged := False;
    
  end;

end;

end.
