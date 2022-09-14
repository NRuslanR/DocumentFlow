unit DocumentPrintFormPresenter;

interface

uses

  DocumentCardFormViewModel,
  DocumentApprovingListSetHolder;

type

  IDocumentPrintFormPresenter = interface

    procedure PresentDocumentPrintFormBy(
      DocumentCardViewModel: TDocumentCardFormViewModel
    ); overload;

    procedure PresentDocumentPrintFormBy(
      DocumentCardViewModel: TDocumentCardFormViewModel;
      DocumentApprovingListSetHolder: TDocumentApprovingListSetHolder
    ); overload;

  end;
  
implementation

end.
