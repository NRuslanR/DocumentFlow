unit StandardUIDocumentKindResolver;

interface

uses

  UIDocumentKindMapper,
  UIDocumentKinds,
  DocumentKindDto,
  UIDocumentKindResolver,
  SysUtils,
  Classes;

type

  TStandardUIDocumentKindResolver =
    class (TInterfacedObject, IUIDocumentKindResolver)

      private

        FUIDocumentKindMapper: IUIDocumentKindMapper;
        FDocumentKindDtos: TDocumentKindDtos;

      public

        destructor Destroy; override;

        constructor Create(
          UIDocumentKindMapper: IUIDocumentKindMapper;
          DocumentKindDtos: TDocumentKindDtos
        );

        function ResolveUIDocumentKindFromId(
          const DocumentKindId: Variant
        ): TUIDocumentKindClass; virtual;

        function ResolveIdForUIDocumentKind(
          UIDocumentKind: TUIDocumentKindClass
        ): Variant; virtual;

    end;

implementation

uses

  Variants;
  
{ TStandardUIDocumentKindResolver }

constructor TStandardUIDocumentKindResolver.Create(
  UIDocumentKindMapper: IUIDocumentKindMapper;
  DocumentKindDtos: TDocumentKindDtos
);
begin

  inherited Create;

  FUIDocumentKindMapper := UIDocumentKindMapper;
  FDocumentKindDtos := DocumentKindDtos;

end;

destructor TStandardUIDocumentKindResolver.Destroy;
begin

  inherited;

end;

function TStandardUIDocumentKindResolver.
  ResolveIdForUIDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): Variant;

var

    DocumentKindDto: TDocumentKindDto;
begin

  DocumentKindDto :=
    FDocumentKindDtos.FindByServiceType(
      FUIDocumentKindMapper.MapDocumentKindFrom(UIDocumentKind)
    );

  if not Assigned(DocumentKindDto) then begin

    raise TUIDocumentKindResolverException.CreateFmt(
      'Не удалось определить идентификатор для ' +
      'сервисного вида документов по интерфейсному ' +
      'виду документов "%s"',
      [
        UIDocumentKind.ClassName
      ]
    );
    
  end

  else Result := DocumentKindDto.Id;

end;

function TStandardUIDocumentKindResolver.
  ResolveUIDocumentKindFromId(
    const DocumentKindId: Variant
  ): TUIDocumentKindClass;

var

    DocumentKindDto: TDocumentKindDto;
begin

  DocumentKindDto := FDocumentKindDtos.FindById(DocumentKindId);

  if not Assigned(DocumentKindDto) then begin

    raise TUIDocumentKindResolverException.Create(
      'Недействительный идентификатор для ' +
      'интерфейсного вида документов'
    );
    
  end;

  Result :=
    FUIDocumentKindMapper.MapUIDocumentKindFrom(
      DocumentKindDto.ServiceType
    );
    
end;

end.
