unit DocumentCardFrameFactories;

interface

uses

  DocumentCardFrameFactory,
  IncomingDocumentCardFrameFactory,
  PersonnelOrderCardFrameFactory,
  ServiceNoteCardFrameFactory,
  UIDocumentKinds,
  SysUtils,
  Classes;

type

  TDocumentCardFrameFactories = class

    protected

      class var FInstance: TDocumentCardFrameFactories;

    protected

      function CreateServiceNoteFrameFactory: TServiceNoteCardFrameFactory;
      function CreatePersonnelOrderFrameFactory: TPersonnelOrderCardFrameFactory;

    protected

      function CreateOrdinaryDocumentCardFrameFactory(
        UIDocumentKind: TUIDocumentKindClass
      ): TDocumentCardFrameFactory; virtual;

      function CreateIncomingDocumentCardFrameFactory(
        UIDocumentKind: TUIIncomingDocumentKindClass
      ): TIncomingDocumentCardFrameFactory; virtual;
      
    public
      
      function CreateDocumentCardFrameFactory(
        UIDocumentKind: TUIDocumentKindClass
      ): TDocumentCardFrameFactory; virtual;

      class property Current: TDocumentCardFrameFactories
      read FInstance write FInstance;
      
  end;

implementation

{ TDocumentCardFrameFactories }

function TDocumentCardFrameFactories.CreateDocumentCardFrameFactory(
  UIDocumentKind: TUIDocumentKindClass
): TDocumentCardFrameFactory;
begin

  {
    refactor(TDocumentCardFrameFactories, 1):
    get factory options from application service's corresponding dto possibly
  }
  if
    UIDocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind)
    or UIDocumentKind.InheritsFrom(TUIApproveableServiceNoteKind)
  then begin

    Result := CreateServiceNoteFrameFactory;

  end

  else if UIDocumentKind.InheritsFrom(TUIPersonnelOrderKind) then begin

    Result := CreatePersonnelOrderFrameFactory;

  end

  else if
    UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind)
    or UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind)
  then begin

    Result :=
      CreateOrdinaryDocumentCardFrameFactory(UIDocumentKind);

  end

  else if
    UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind)
  then begin

    Result :=
      CreateIncomingDocumentCardFrameFactory(
        TUIIncomingDocumentKindClass(UIDocumentKind)
      );

  end

  else begin

    Raise Exception.Create(
      'Для документа данного вида не реализована ' +
      'возможность создания карточки'
    );

  end;

end;

function TDocumentCardFrameFactories.CreateIncomingDocumentCardFrameFactory(
  UIDocumentKind: TUIIncomingDocumentKindClass
): TIncomingDocumentCardFrameFactory;
begin

  Result :=
    TIncomingDocumentCardFrameFactory.Create(
      CreateDocumentCardFrameFactory(UIDocumentKind.OutcomingDocumentKind)
    );

end;

function TDocumentCardFrameFactories.CreateOrdinaryDocumentCardFrameFactory(
  UIDocumentKind: TUIDocumentKindClass): TDocumentCardFrameFactory;
begin

  Result := TDocumentCardFrameFactory.Create;
  
end;

function TDocumentCardFrameFactories.CreatePersonnelOrderFrameFactory: TPersonnelOrderCardFrameFactory;
begin

  Result :=
    TPersonnelOrderCardFrameFactory.Create(
      TDocumentCardFrameFactoryOptions
        .Create
          .DocumentFormPrintToolRequired(False)
          .ApprovingSheetPrintToolRequired(True)
    );
end;

function TDocumentCardFrameFactories.CreateServiceNoteFrameFactory: TServiceNoteCardFrameFactory;
begin

  Result := TServiceNoteCardFrameFactory.Create;

end;

end.
