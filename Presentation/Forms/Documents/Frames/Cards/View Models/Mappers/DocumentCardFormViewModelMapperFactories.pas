unit DocumentCardFormViewModelMapperFactories;

interface

uses

  UIDocumentKinds,
  DocumentCardFormViewModelMapperFactory,
  IncomingDocumentCardFormViewModelMapperFactory,
  DocumentDataSetHoldersFactory,
  DocumentDataSetHoldersFactories,
  PersonnelOrderCardFormViewModelMapperFactory,
  SysUtils,
  Classes;

type

  TDocumentCardFormViewModelMapperFactories = class

    protected

      class var FInstance: TDocumentCardFormViewModelMapperFactories;

    protected

      FDocumentDataSetHoldersFactories: IDocumentDataSetHoldersFactories;

      function CreateOrdinaryDocumentCardFormViewModelMapperFactory(
        UIDocumentKind: TUIDocumentKindClass;
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      ): TDocumentCardFormViewModelMapperFactory; virtual;

      function CreateIncomingDocumentCardFormViewModelMapperFactory(
        UIDocumentKind: TUIDocumentKindClass;
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      ): TIncomingDocumentCardFormViewModelMapperFactory; virtual;

      function CreatePersonnelOrderCardFormViewModelMapperFactory(
        UIDocumentKind: TUIDocumentKindClass;
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      ): TPersonnelOrderCardFormViewModelMapperFactory; 

    public

      constructor Create(DocumentDataSetHoldersFactories: IDocumentDataSetHoldersFactories);
      
      function CreateDocumentCardFormViewModelMapperFactory(
        UIDocumentKind: TUIDocumentKindClass
      ): TDocumentCardFormViewModelMapperFactory; virtual;

      class property Current: TDocumentCardFormViewModelMapperFactories
      read FInstance write FInstance;
      
  end;
  
implementation

uses

  OutcomingServiceNoteCardFormViewModelMapperFactory,
  IncomingServiceNoteCardFormViewModelMapperFactory;

{ TDocumentCardFormViewModelMapperFactories }

constructor TDocumentCardFormViewModelMapperFactories.Create(
  DocumentDataSetHoldersFactories: IDocumentDataSetHoldersFactories);
begin

  inherited Create;

  FDocumentDataSetHoldersFactories := DocumentDataSetHoldersFactories;
  
end;

function TDocumentCardFormViewModelMapperFactories.
  CreateDocumentCardFormViewModelMapperFactory(
    UIDocumentKind: TUIDocumentKindClass
  ): TDocumentCardFormViewModelMapperFactory;
var
    DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
begin

  DocumentDataSetHoldersFactory :=
    FDocumentDataSetHoldersFactories.GetDocumentDataSetHoldersFactory(UIDocumentKind);
    
  if
    UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) or
    UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind) or
    UIDocumentKind.InheritsFrom(TUIInternalDocumentKind)
  then begin

    Result :=
      CreateOrdinaryDocumentCardFormViewModelMapperFactory(
        UIDocumentKind, DocumentDataSetHoldersFactory
      );

  end

  else if
    UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) or
    UIDocumentKind.InheritsFrom(TUIIncomingInternalServiceNoteKind)
  then begin

    Result :=
      CreateIncomingDocumentCardFormViewModelMapperFactory(
        UIDocumentKind, DocumentDataSetHoldersFactory
      );

  end

  else if UIDocumentKind.InheritsFrom(TUIPersonnelOrderKind) then begin

    Result :=
      CreatePersonnelOrderCardFormViewModelMapperFactory(
        UIDocumentKind, DocumentDataSetHoldersFactory
      );

  end

  else begin

    Raise Exception.Create(
      'TDocumentCardFormViewModelMapperFactories.' +
      'CreateDocumentCardFormViewModelMapperFactory'
    );

  end;

end;

function TDocumentCardFormViewModelMapperFactories.
  CreateOrdinaryDocumentCardFormViewModelMapperFactory(
    UIDocumentKind: TUIDocumentKindClass;
    DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
  ): TDocumentCardFormViewModelMapperFactory;
begin

  if
    (UIDocumentKind = TUIOutcomingServiceNoteKind) or
    (UIDocumentKind = TUIInternalServiceNoteKind) 
  then
    Result := TOutcomingServiceNoteCardFormViewModelMapperFactory.Create(DocumentDataSetHoldersFactory)

  else Result := TDocumentCardFormViewModelMapperFactory.Create(DocumentDataSetHoldersFactory);
  
end;

function TDocumentCardFormViewModelMapperFactories.CreatePersonnelOrderCardFormViewModelMapperFactory(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
): TPersonnelOrderCardFormViewModelMapperFactory;
begin

  Result := TPersonnelOrderCardFormViewModelMapperFactory.Create(DocumentDataSetHoldersFactory);
end;

function TDocumentCardFormViewModelMapperFactories.
  CreateIncomingDocumentCardFormViewModelMapperFactory(
    UIDocumentKind: TUIDocumentKindClass;
    DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
  ): TIncomingDocumentCardFormViewModelMapperFactory;
var

  OutcomingDocumentCardFormViewModelMapperFactory:
    TDocumentCardFormViewModelMapperFactory;

  OutcomingDocumentKind: TUIDocumentKindClass;
begin

  if UIDocumentKind.InheritsFrom(TUIIncomingInternalDocumentKind) then begin

    OutcomingDocumentKind :=
      TUIIncomingInternalDocumentKindClass(UIDocumentKind).InternalDocumentKind;

  end

  else begin

    OutcomingDocumentKind :=
      TUIIncomingDocumentKindClass(UIDocumentKind).OutcomingDocumentKind;

  end;

  OutcomingDocumentCardFormViewModelMapperFactory :=
    CreateOrdinaryDocumentCardFormViewModelMapperFactory(
      OutcomingDocumentKind, DocumentDataSetHoldersFactory
    );

  if
    (UIDocumentKind = TUIIncomingServiceNoteKind) or
    (UIDocumentKind = TUIIncomingInternalServiceNoteKind)
  then begin

    Result :=
      TIncomingServiceNoteCardFormViewModelMapperFactory.Create(
        OutcomingDocumentCardFormViewModelMapperFactory as
          TOutcomingServiceNoteCardFormViewModelMapperFactory,
        DocumentDataSetHoldersFactory
      );

  end

  else begin

    Result :=
      TIncomingDocumentCardFormViewModelMapperFactory.Create(
        OutcomingDocumentCardFormViewModelMapperFactory,
        DocumentDataSetHoldersFactory
      );
      
  end;

end;


end.
