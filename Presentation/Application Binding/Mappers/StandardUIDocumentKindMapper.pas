unit StandardUIDocumentKindMapper;

interface

uses

  DocumentKinds,
  UIDocumentKindMapper,
  UIDocumentKinds,
  SysUtils,
  Classes;

type

  TStandardUIDocumentKindMapper = class (TInterfacedObject, IUIDocumentKindMapper)

    public

      function MapDocumentKindFrom(
        UIDocumentKind: TUIDocumentKindClass
      ): TDocumentKindClass;

      function MapUIDocumentKindFrom(
        DocumentKind: TDocumentKindClass
      ): TUIDocumentKindClass;

  end;
  
implementation

{ TStandardUIDocumentKindMapper }

function TStandardUIDocumentKindMapper.MapDocumentKindFrom(
  UIDocumentKind: TUIDocumentKindClass
): TDocumentKindClass;
begin

  if UIDocumentKind = TUIServiceNoteKind then
    Result := TServiceNoteKind

  else if UIDocumentKind = TUIOutcomingServiceNoteKind then
    Result := TOutcomingServiceNoteKind

  else if UIDocumentKind = TUIApproveableServiceNoteKind then
    Result := TApproveableServiceNoteKind
       
  else if UIDocumentKind = TUIIncomingServiceNoteKind then
    Result := TIncomingServiceNoteKind

  else if UIDocumentKind = TUIInternalServiceNoteKind then
    Result := TInternalServiceNoteKind

  else if UIDocumentKind = TUIIncomingInternalServiceNoteKind then
    Result := TIncomingInternalServiceNoteKind

  else if UIDocumentKind = TUIPersonnelOrderKind then
    Result := TPersonnelOrderKind

  else if UIDocumentKind = TUISDDocumentKind then
    Result := TSDDocumentKind

  else if UIDocumentKind = TUIPlantDocumentKind then
    Result := TPlantDocumentKind
    
  else begin

    raise Exception.Create(
      'Не удалось распознать сервисный вид документа ' +
      'по интерфейсному'
    );

  end;
  
end;

function TStandardUIDocumentKindMapper.MapUIDocumentKindFrom(
  DocumentKind: TDocumentKindClass): TUIDocumentKindClass;
begin

  if DocumentKind = TServiceNoteKind then
    Result := TUIServiceNoteKind

  else if DocumentKind = TOutcomingServiceNoteKind then
    Result := TUIOutcomingServiceNoteKind

  else if DocumentKind = TApproveableServiceNoteKind then
    Result := TUIApproveableServiceNoteKind
    
  else if DocumentKind = TIncomingServiceNoteKind then
    Result := TUIIncomingServiceNoteKind

  else if DocumentKind = TInternalServiceNoteKind then
    Result := TUIInternalServiceNoteKind

  else if DocumentKind = TIncomingInternalServiceNoteKind then
    Result := TUIIncomingInternalServiceNoteKind

  else if DocumentKind = TPersonnelOrderKind then
    Result := TUIPersonnelOrderKind
    
  else if DocumentKind = TSDDocumentKind then
    Result := TUISDDocumentKind

  else if DocumentKind = TPlantDocumentKind then
    Result := TUIPlantDocumentKind

  else if DocumentKind = TResourceRequestsKind then
    Result := TUIResourceRequestsDocumentKind
    
  else begin

    raise Exception.Create(
      'Не удалось распознать интерфейсный вид документа ' +
      'по сервисному'
    );

  end;
  
end;

end.
