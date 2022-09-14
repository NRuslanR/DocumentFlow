unit DocumentRelationsFormViewModelUnit;

interface

uses

  SysUtils,
  Classes,
  DocumentRelationSetHolder,
  DB;

type

  TDocumentRelationsFormViewModel = class

    protected

      { В будущем добавить поля
        хранения наименований столбцов
        для табличного отображения }

      FDocumentRelationSetHolder:
        TDocumentRelationSetHolder;

      procedure SetDocumentRelationSetHolder(
        DocumentRelationSetHolder:
          TDocumentRelationSetHolder
      );

    public

      destructor Destroy; override;

      property DocumentRelationSetHolder:
        TDocumentRelationSetHolder
      read FDocumentRelationSetHolder
      write FDocumentRelationSetHolder;

  end;

  TDocumentRelationsPageViewModelClass =
    class of TDocumentRelationsFormViewModel;

implementation

{ TDocumentRelationsFormViewModel }

destructor TDocumentRelationsFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentRelationSetHolder);
  inherited;

end;

procedure TDocumentRelationsFormViewModel.SetDocumentRelationSetHolder(
  DocumentRelationSetHolder:
    TDocumentRelationSetHolder
);
begin

  if

    DocumentRelationSetHolder <>
    DocumentRelationSetHolder

  then FreeAndNil(FDocumentRelationSetHolder);

  FDocumentRelationSetHolder :=
    DocumentRelationSetHolder;

end;

end.

