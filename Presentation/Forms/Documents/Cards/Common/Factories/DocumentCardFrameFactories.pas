unit DocumentCardFrameFactories;

interface

uses

  DocumentCardFrameFactory,
  IncomingDocumentCardFrameFactory,
  PersonnelOrderCardFrameFactory,
  UIDocumentKinds,
  SysUtils,
  Classes;

type

  TDocumentCardFrameFactories = class

    protected

      class var FInstance: TDocumentCardFrameFactories;

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
    UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) or
    UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind) or
    UIDocumentKind.InheritsFrom(TUIInternalDocumentKind)
  then begin

    Result :=
      CreateOrdinaryDocumentCardFrameFactory(UIDocumentKind);

  end

  else if
    UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) or
    UIDocumentKind.InheritsFrom(TUIIncomingInternalDocumentKind)
  then begin

    Result := CreateIncomingDocumentCardFrameFactory(
                TUIIncomingDocumentKindClass(UIDocumentKind)
              );

  end

  else if UIDocumentKind.InheritsFrom(TUIPersonnelOrderKind) then begin

    Result :=
      TPersonnelOrderCardFrameFactory.Create(
        TDocumentCardFrameFactoryOptions
          .Create
            .DocumentFormPrintToolRequired(False)   
            .ApprovingSheetPrintToolRequired(True)
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

  Result := TIncomingDocumentCardFrameFactory.Create;

end;

function TDocumentCardFrameFactories.CreateOrdinaryDocumentCardFrameFactory(
  UIDocumentKind: TUIDocumentKindClass): TDocumentCardFrameFactory;
begin

  Result := TDocumentCardFrameFactory.Create;
  
end;

end.
