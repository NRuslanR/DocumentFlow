unit unSelectionDocumentsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSelectionDocumentsWorkingFrame, DocumentRecordViewModel;

type
  TSelectionDocumentsForm = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    private

      FSelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame;

    private

      procedure CloseSuccessfully;

      procedure OnDocumentsChoosedEventHandler(
        Sender: TObject;
        ChoosedDocuments: TDocumentRecordViewModels
      );

    private

      procedure InflateSelectionDocumentsWorkingFrame(
        SelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame
      );

      procedure SetSelectionDocumentsWorkingFrame(
        const Value: TSelectionDocumentsWorkingFrame
      );
      
      function GetSelectedDocumentRecords: TDocumentRecordViewModels;

    public

      constructor Create(
        AOwner: TComponent;
        SelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame
      );

      property SelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame
      read FSelectionDocumentsWorkingFrame write SetSelectionDocumentsWorkingFrame;

      property SelectedDocumentRecords: TDocumentRecordViewModels
      read GetSelectedDocumentRecords;

  end;

var
  SelectionDocumentsForm: TSelectionDocumentsForm;

implementation

{$R *.dfm}

procedure TSelectionDocumentsForm.CloseSuccessfully;
begin

  if fsModal in FFormState then begin

    ModalResult := mrOk;
    CloseModal;

  end

  else Close;

end;

constructor TSelectionDocumentsForm.Create(
  AOwner: TComponent;
  SelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame
);
begin

  inherited Create(AOwner);

  Self.SelectionDocumentsWorkingFrame := SelectionDocumentsWorkingFrame;
  
end;

procedure TSelectionDocumentsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  SelectionDocumentsWorkingFrame.OnClose;
  
end;

procedure TSelectionDocumentsForm.FormShow(Sender: TObject);
begin

  if Assigned(SelectionDocumentsWorkingFrame) then
    SelectionDocumentsWorkingFrame.OnShow;
    
end;

function TSelectionDocumentsForm.GetSelectedDocumentRecords: TDocumentRecordViewModels;
begin

  if Assigned(SelectionDocumentsWorkingFrame) then
    Result := SelectionDocumentsWorkingFrame.SelectedDocumentRecords

  else Result := nil;
  
end;

procedure TSelectionDocumentsForm.InflateSelectionDocumentsWorkingFrame(
  SelectionDocumentsWorkingFrame: TSelectionDocumentsWorkingFrame
);
begin

  SelectionDocumentsWorkingFrame.Parent := Self;
  SelectionDocumentsWorkingFrame.Align := alClient;
  
end;

procedure TSelectionDocumentsForm.OnDocumentsChoosedEventHandler(
  Sender: TObject;
  ChoosedDocuments: TDocumentRecordViewModels
);
begin

  CloseSuccessfully;
  
end;

procedure TSelectionDocumentsForm.SetSelectionDocumentsWorkingFrame(
  const Value: TSelectionDocumentsWorkingFrame);
begin

  if FSelectionDocumentsWorkingFrame = Value then Exit;

  FreeAndNil(FSelectionDocumentsWorkingFrame);

  FSelectionDocumentsWorkingFrame := Value;

  InflateSelectionDocumentsWorkingFrame(FSelectionDocumentsWorkingFrame);
  
  FSelectionDocumentsWorkingFrame
    .DocumentCardListFrame
      .OnDocumentsChoosedEventHandler :=
        OnDocumentsChoosedEventHandler;

end;

end.
