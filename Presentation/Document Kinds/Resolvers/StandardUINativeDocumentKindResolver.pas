unit StandardUINativeDocumentKindResolver;

interface

uses

  UINativeDocumentKindResolver,
  StandardUIDocumentKindResolver,
  UIDocumentKindMapper,
  DocumentKindDto,
  NativeDocumentKindDto,
  UIDocumentKinds,
  SysUtils;

type

  TStandardUINativeDocumentKindResolver =
    class (TStandardUIDocumentKindResolver, IUINativeDocumentKindResolver)

      public

        constructor Create(
          UIDocumentKindMapper: IUIDocumentKindMapper;
          NativeDocumentKindDtos: TNativeDocumentKindDtos
        );
      
    end;

implementation

{ TStandardUINativeDocumentKindResolver }

constructor TStandardUINativeDocumentKindResolver.Create(
  UIDocumentKindMapper: IUIDocumentKindMapper;
  NativeDocumentKindDtos: TNativeDocumentKindDtos);
begin

  inherited Create(UIDocumentKindMapper, NativeDocumentKindDtos);
  
end;

end.
