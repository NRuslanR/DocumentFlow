unit AbstractDocumentSetHolderFactoryDecorator;

interface

uses

  DocumentSetHolderFactory,
  DocumentSetHolder,
  AbstractDocumentSetHolderDecorator,
  SysUtils;

type

  TAbstractDocumentSetHolderFactoryDecorator =
    class (TDocumentSetHolderFactory)

      protected

        FOriginalDocumentSetHolderFactory: TDocumentSetHolderFactory;
        
      protected

        function GetDocumentSetHolderDecoratorClass: TAbstractDocumentSetHolderDecoratorClass; virtual; abstract;
        
        function CreateDocumentSetHolderInstance: TDocumentSetHolder; override;
        procedure FillDocumentSetFieldDefs(DocumentSetHolder: TDocumentSetHolder); override;

      public

        destructor Destroy; override;

        constructor Create(OriginalDocumentSetHolderFactory: TDocumentSetHolderFactory);

    end;

implementation

{ TAbstractDocumentSetHolderFactoryDecorator }

constructor TAbstractDocumentSetHolderFactoryDecorator.Create(
  OriginalDocumentSetHolderFactory: TDocumentSetHolderFactory);
begin

  inherited Create;

  FOriginalDocumentSetHolderFactory := OriginalDocumentSetHolderFactory;
  
end;

destructor TAbstractDocumentSetHolderFactoryDecorator.Destroy;
begin

  FreeAndNil(FOriginalDocumentSetHolderFactory);

  inherited;

end;

function TAbstractDocumentSetHolderFactoryDecorator.CreateDocumentSetHolderInstance: TDocumentSetHolder;
var
    InternalDocumentSetHolder: TDocumentSetHolder;
begin

  InternalDocumentSetHolder :=
    FOriginalDocumentSetHolderFactory.CreateDocumentSetHolder;
    
  Result :=
    GetDocumentSetHolderDecoratorClass.CreateFrom(InternalDocumentSetHolder);

  TAbstractDocumentSetFieldDefsDecorator(
    TAbstractDocumentSetHolderDecorator(Result).FieldDefs
  ).OriginalDocumentSetFieldDefs := InternalDocumentSetHolder.FieldDefs;

end;

procedure TAbstractDocumentSetHolderFactoryDecorator.FillDocumentSetFieldDefs(
  DocumentSetHolder: TDocumentSetHolder
);
begin

end;

end.
