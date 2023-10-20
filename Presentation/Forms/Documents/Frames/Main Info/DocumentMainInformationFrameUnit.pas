unit DocumentMainInformationFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ValidateEditUnit, RegExprValidateEditUnit,
  unDocumentCardInformationFrame, ExtCtrls, ValidateMemoUnit,
  RegExprValidateMemoUnit, DocumentMainInformationFormViewModelUnit,
  HorizontalBoxLayoutManager, VerticalBoxLayoutManager,
  ColumnarCellAlignedLayoutManager, LayoutManager, VariantListUnit,
  AuxWindowsFunctionsUnit, ValidateRichEdit, RegExprValidateRichEdit,
  SourcedEventHandlers,
  RichEdit;

type

  TDocumentMainInformationFrame = class(TDocumentCardInformationFrame)
    DocumentTypeLabel: TLabel;
    DocumentTypeEdit: TRegExprValidateEdit;
    DocumentNumberLabel: TLabel;
    DocumentNumberPrefixEdit: TRegExprValidateEdit;
    DocumentNumberMainValueEdit: TRegExprValidateEdit;
    DocumentCreationDateLabel: TLabel;
    DocumentCreationDateTimePicker: TDateTimePicker;
    DocumentNameLabel: TLabel;
    DocumentNameEdit: TRegExprValidateEdit;
    DocumentContentLabel: TLabel;
    DocumentNoteLabel: TLabel;
    DocumentNoteMemo: TRegExprValidateMemo;
    DocumentContentMemo: TRegExprValidateRichEdit;
    DocumentIsSelfRegisteredCheckBox: TCheckBox;
    DocumentDateTimePicker: TDateTimePicker;
    DocumentDateLabel: TLabel;
    procedure DocumentContentMemoChange(Sender: TObject);
    procedure DocumentCreationDateTimePickerCloseUp(Sender: TObject);
    procedure DocumentDateTimePickerCloseUp(Sender: TObject);

  protected

    FControlsAnchors: TAnchorsArray;
    
    FViewModel: TDocumentMainInformationFormViewModel;

    FInitialViewModel: TDocumentMainInformationFormViewModel;

  private

    FDocumentNumberPrefixChangedEventHandler: ISourcedEventHandler;
    FDocumentNumberMainValueChangedEventHandler: ISourcedEventHandler;

    procedure OnDocumentNumberPrefixChanged(Sender: TObject);
    procedure OnDocumentNumberMainValueChanged(Sender: TObject);

    procedure UpdateValidationPropsOfDocumentNumberEdits;

  protected

    procedure Initialize; override;

  protected

    function GetDocumentNumberReadOnly: Boolean;
    procedure SetDocumentNumberReadOnly(const Value: Boolean);
    
  protected

    function GetAsSelfRegisteredDocumentMarkingToolEnabled: Boolean;
    procedure SetAsSelfRegisteredDocumentMarkingToolEnabled(
      const Value: Boolean
    );

  protected

    procedure OnPropertyChangedEventHandler(
      Sender: TObject;
      const PropertyName: String
    );

  protected

    procedure FillUIElementsFromViewModel(ViewModel: TDocumentMainInformationFormViewModel);
    procedure SetEnabled(Value: Boolean); override;

    function GetViewModel: TDocumentMainInformationFormViewModel; virtual;
    procedure SetViewModel(ViewModel: TDocumentMainInformationFormViewModel); virtual;

    function GetHorizontalScrollingMinWidth: Integer; override;
    function GetVerticalScrollingMinHeight: Integer; override;

    procedure AdjustLayout;
    
    procedure BuildLayout;
    procedure OnLayoutBuilded; virtual;

    procedure DisableRichEditFormatting;

    function CreateLayoutManager: TLayoutManager; virtual;

    procedure OnFontChanged(var Message: TMessage); message CM_FONTCHANGED; 

    procedure SetNotAllowedForEditingControls(Controls:  TList); override;
    
  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    procedure OnChangesApplied; override;
    procedure OnChangesApplyingFailed; override;

    function IsDataChanged: Boolean; override;

    function ValidateInput: Boolean; override;

    property DocumentNumberReadOnly: Boolean
    read GetDocumentNumberReadOnly write SetDocumentNumberReadOnly; { refactor: get access rights, fill necessarity for field set from dto }
  
    property ViewModel: TDocumentMainInformationFormViewModel
    read GetViewModel write SetViewModel;

    property AsSelfRegisteredDocumentMarkingToolEnabled: Boolean
    read GetAsSelfRegisteredDocumentMarkingToolEnabled
    write SetAsSelfRegisteredDocumentMarkingToolEnabled;

  end;

implementation

uses

  EventHandlerChains,
  CommCtrl,
  DateUtils,
  AuxDebugFunctionsUnit;

const

  DOCUMENT_NUMBER_MAIN_VALUE_REG_EXPR = '.+';

  DOCUMENT_NUMBER_MAIN_VALUE_INVALID_HINT =
    'Не задан номер документа';

{$R *.dfm}

{ TDocumentMainInformationFrame }

procedure TDocumentMainInformationFrame.AdjustLayout;
begin

  DocumentNoteMemo.Top :=
    DocumentContentMemo.Top + DocumentContentMemo.Height + 6;

  DocumentNoteLabel.Top := DocumentNoteMemo.Top;

  DocumentInfoPanel.Height :=
    DocumentNoteMemo.Top + DocumentNoteMemo.Height + 10;

end;

procedure TDocumentMainInformationFrame.BuildLayout;
var LayoutManager: TLayoutManager;
begin

  FControlsAnchors := DisableAnchorsFor(DocumentInfoPanel);
  
  LayoutManager := CreateLayoutManager;

  LayoutManager.Top := 5;
  LayoutManager.Left := 5;

  LayoutManager.ApplyLayout;

  DocumentInfoPanel.Width := LayoutManager.Right + 5;
  DocumentInfoPanel.Height := LayoutManager.Bottom + 5;

  OnLayoutBuilded;

  EnableAnchorsFor(DocumentInfoPanel, FControlsAnchors);
  
  LayoutManager.Free;
  
end;

function TDocumentMainInformationFrame.CreateLayoutManager: TLayoutManager;
begin
                           
  Result :=

    TColumnarCellAlignedLayoutManagerBuilder.Create.AddLayoutManagers(
      [
        TVerticalBoxLayoutManagerBuilder.Create.AddControls(
          [
            DocumentTypeLabel,
            DocumentNameLabel,
            DocumentContentLabel,
            DocumentNoteLabel
          ],
          [8, 8, 8, 8]
        )
        .SetId('LabelColumn')
        .BuildAndDestroy,

        TVerticalBoxLayoutManagerBuilder(
          TVerticalBoxLayoutManagerBuilder.Create.AddLayoutManager(
            THorizontalBoxLayoutManagerBuilder.Create.AddControls(
              [
                DocumentTypeEdit,
                DocumentNumberLabel,
                DocumentNumberPrefixEdit,
                DocumentNumberMainValueEdit,
                DocumentDateLabel,
                DocumentDateTimePicker,
                DocumentCreationDateLabel,
                DocumentCreationDateTimePicker,
                DocumentIsSelfRegisteredCheckBox
              ],
              [10, 5, 5, 10, 5, 10, 5, 10]
            )
            .SetId('DocumentTypeRow')
            .BuildAndDestroy,
            6
          )
          .SetId('EditColumn')
        )
        .AddControls(
          [
            DocumentNameEdit,
            DocumentContentMemo,
            DocumentNoteMemo
          ],
          [8, 8, 8]
        ).BuildAndDestroy
      ]
    ).BuildAndDestroy;

end;

constructor TDocumentMainInformationFrame.Create(AOwner: TComponent);
begin

  inherited;

  BuildLayout;

end;

destructor TDocumentMainInformationFrame.Destroy;
begin

  FreeAndNil(FInitialViewModel);
  
  inherited;

end;

procedure TDocumentMainInformationFrame.DisableRichEditFormatting;
var CharFormat: TCharFormat2;
begin

  ZeroMemory(@CharFormat, SizeOf(CharFormat));

  CharFormat.cbSize := SizeOf(CharFormat);

  SendMessage(
    DocumentContentMemo.Handle,
    EM_GETCHARFORMAT,
    SCF_DEFAULT,
    Integer(@CharFormat)
  );

  SendMessage(
    DocumentContentMemo.Handle,
    EM_SETCHARFORMAT,
    SCF_ALL,
    Integer(@CharFormat)
  );

end;

procedure TDocumentMainInformationFrame.DocumentContentMemoChange(
  Sender: TObject);
begin
  inherited;

//  DisableRichEditFormatting;

  DocumentContentMemo.CheckValidAndUpdateView;

end;

procedure TDocumentMainInformationFrame.DocumentCreationDateTimePickerCloseUp(
  Sender: TObject);
var
    CurrentDate: TDateTime;
begin

  inherited;

  CurrentDate := DateOf(Now);

  if DateOf(DocumentCreationDateTimePicker.DateTime) > CurrentDate then begin

    DocumentCreationDateTimePicker.DateTime := CurrentDate;

    ShowInfoMessage(
      Self.Handle,
      'На данный момент установка ' +
      'будущей даты создания документа ' +
      'не позволительна',
      'Сообщение'
    );

  end;
  
end;

procedure TDocumentMainInformationFrame.DocumentDateTimePickerCloseUp(
  Sender: TObject);
var
    CurrentDate: TDateTime;
begin

  inherited;

  CurrentDate := DateOf(Now);

  if DateOf(DocumentDateTimePicker.DateTime) > CurrentDate then begin

    DocumentDateTimePicker.DateTime := CurrentDate;

    ShowInfoMessage(
      Self.Handle,
      'На данный момент установка ' +
      'будущей даты документа ' +
      'не позволительна',
      'Сообщение'
    );

  end;

end;

procedure TDocumentMainInformationFrame.FillUIElementsFromViewModel(
  ViewModel: TDocumentMainInformationFormViewModel
);
begin

  DocumentTypeEdit.Text := ViewModel.Kind;
  DocumentNameEdit.Text := ViewModel.Name;

  DocumentNumberPrefixEdit.Text := ViewModel.NumberPrefix;
  DocumentNumberPrefixEdit.RegularExpression := ViewModel.NumberPrefixPattern;
  DocumentNumberPrefixEdit.InvalidHint := 'Префикс номера документа ' +
    'должен состоять из цифр. Разрешены символы - и / для разделения частей префикса';
    
  DocumentNumberMainValueEdit.Text := ViewModel.NumberMainValue;

  DocumentNumberMainValueEdit.RegularExpression :=
    DOCUMENT_NUMBER_MAIN_VALUE_REG_EXPR;

  DocumentNumberMainValueEdit.InvalidHint :=
    DOCUMENT_NUMBER_MAIN_VALUE_INVALID_HINT;
    
  DocumentCreationDateTimePicker.DateTime := ViewModel.CreationDate;

  if not VarIsNull(ViewModel.DocumentDate) then
    DocumentDateTimePicker.DateTime := ViewModel.DocumentDate

  else ViewModel.DocumentDate := DocumentDateTimePicker.DateTime;
    
  DocumentContentMemo.Text := ViewModel.Content;
  DocumentNoteMemo.Text := ViewModel.Note;

  if not VarIsNull(ViewModel.IsSelfRegistered) then
    DocumentIsSelfRegisteredCheckBox.Checked := ViewModel.IsSelfRegistered

  else ViewModel.IsSelfRegistered := DocumentIsSelfRegisteredCheckBox.Checked;

end;

function TDocumentMainInformationFrame.GetAsSelfRegisteredDocumentMarkingToolEnabled: Boolean;
begin

  Result := DocumentIsSelfRegisteredCheckBox.Enabled;
  
end;

function TDocumentMainInformationFrame.GetDocumentNumberReadOnly: Boolean;
begin

  Result := DocumentNumberMainValueEdit.ReadOnly;
  
end;

function TDocumentMainInformationFrame.GetHorizontalScrollingMinWidth: Integer;
begin

  Result := inherited GetHorizontalScrollingMinWidth;
  
end;

function TDocumentMainInformationFrame.GetVerticalScrollingMinHeight: Integer;
begin

  Result := inherited GetVerticalScrollingMinHeight; 
  
end;

function TDocumentMainInformationFrame.GetViewModel: TDocumentMainInformationFormViewModel;
begin

  Result := FViewModel;
                                                       
  if not Assigned(FViewModel) then Exit;

  FViewModel.Kind := DocumentTypeEdit.Text;
  FViewModel.NumberPrefix := DocumentNumberPrefixEdit.Text;
  FViewModel.NumberMainValue := DocumentNumberMainValueEdit.Text;
  FViewModel.CreationDate := DocumentCreationDateTimePicker.DateTime;
  FViewModel.DocumentDate := DocumentDateTimePicker.DateTime;
  FViewModel.Name := DocumentNameEdit.Text;
  FViewModel.Content := DocumentContentMemo.Text;
  FViewModel.Note := DocumentNoteMemo.Text;
  FViewModel.IsSelfRegistered := DocumentIsSelfRegisteredCheckBox.Checked;

end;

procedure TDocumentMainInformationFrame.Initialize;
begin

  inherited Initialize;

  DocumentDateTimePicker.DateTime := Now;

  FDocumentNumberPrefixChangedEventHandler :=
    TSourcedEventHandlerChain.CreateWrapperChain([
      OnDocumentNumberPrefixChanged, DocumentNumberPrefixEdit.OnChange
    ]);

  DocumentNumberPrefixEdit.OnChange :=
    TAbstractSourcedEventHandler(FDocumentNumberPrefixChangedEventHandler.Self).Handle;

  FDocumentNumberMainValueChangedEventHandler :=
    TSourcedEventHandlerChain.CreateWrapperChain([
      OnDocumentNumberMainValueChanged, DocumentNumberMainValueEdit.OnChange
    ]);

  DocumentNumberMainValueEdit.OnChange :=
    TAbstractSourcedEventHandler(FDocumentNumberMainValueChangedEventHandler.Self).Handle;
  
end;

function TDocumentMainInformationFrame.IsDataChanged: Boolean;
begin

  if Assigned(FInitialViewModel) and not VarIsNull(FInitialViewModel.DocumentId)
  then begin

    Result :=
      Assigned(FInitialViewModel) and (
      (FInitialViewModel.CreationDate <> DocumentCreationDateTimePicker.DateTime) or
      (not VarIsNull(FInitialViewModel.DocumentDate) and (FInitialViewModel.DocumentDate <> DocumentDateTimePicker.DateTime)) or
      (FInitialViewModel.Name <> DocumentNameEdit.Text) or
      (FInitialViewModel.Content <> DocumentContentMemo.Text) or
      (FInitialViewModel.Note <> DocumentNoteMemo.Text) or
      (not VarIsNull(FInitialViewModel.IsSelfRegistered) and (FInitialViewModel.IsSelfRegistered <> DocumentIsSelfRegisteredCheckBox.Checked)) or
      (FInitialViewModel.NumberMainValue <> DocumentNumberMainValueEdit.Text) or
      (FInitialViewModel.NumberPrefix <> DocumentNumberPrefixEdit.Text));

  end

  else begin

    Result :=
      (Trim(DocumentNameEdit.Text) <> '') or
      (Trim(DocumentContentMemo.Text) <> '') or
      (Trim(DocumentNoteMemo.Text) <> '') or
      (Trim(DocumentNumberMainValueEdit.Text) <> '') or
      (Trim(DocumentNumberPrefixEdit.Text) <> '');
      
  end;

end;


procedure TDocumentMainInformationFrame.OnFontChanged(var Message: TMessage);
begin

  inherited;
  
  BuildLayout;

end;

procedure TDocumentMainInformationFrame.OnLayoutBuilded;
begin

  DocumentNameEdit.Width :=
    DocumentInfoPanel.Width - DocumentNameEdit.Left - 5;
    
  DocumentContentMemo.Width :=
    DocumentInfoPanel.Width - DocumentContentMemo.Left - 5;

  DocumentNoteMemo.Width :=
    DocumentInfoPanel.Width - DocumentNoteMemo.Left - 5;

end;

procedure TDocumentMainInformationFrame.OnPropertyChangedEventHandler(
  Sender: TObject;
  const PropertyName: String
);
begin

  if PropertyName = 'Number' then begin

    DocumentNumberPrefixEdit.Text :=
      FViewModel.NumberPrefix;

    DocumentNumberMainValueEdit.Text :=
      FViewModel.NumberMainValue;
      
  end;

end;

procedure TDocumentMainInformationFrame.OnChangesApplied;
begin

  if not Assigned(ViewModel) then Exit;

  FInitialViewModel.CopyFrom(ViewModel);
  
end;

procedure TDocumentMainInformationFrame.OnChangesApplyingFailed;
begin

  inherited;

end;

procedure TDocumentMainInformationFrame.OnDocumentNumberMainValueChanged(
  Sender: TObject);
begin

  UpdateValidationPropsOfDocumentNumberEdits;
  
end;

procedure TDocumentMainInformationFrame.OnDocumentNumberPrefixChanged(
  Sender: TObject);
begin

  UpdateValidationPropsOfDocumentNumberEdits;

end;

procedure TDocumentMainInformationFrame.
  SetAsSelfRegisteredDocumentMarkingToolEnabled(
    const Value: Boolean
  );
begin

  DocumentIsSelfRegisteredCheckBox.Enabled := Value;
  
end;

procedure TDocumentMainInformationFrame.SetDocumentNumberReadOnly(
  const Value: Boolean);
begin

  DocumentNumberPrefixEdit.ReadOnly := Value;
  DocumentNumberMainValueEdit.ReadOnly := Value;
  
end;

procedure TDocumentMainInformationFrame.SetEnabled(Value: Boolean);
begin

  DocumentInfoPanel.Enabled := Value;
  
end;

procedure TDocumentMainInformationFrame.SetNotAllowedForEditingControls(
  Controls: TList
);
begin

  inherited;

  Controls.Add(DocumentTypeEdit);

end;

procedure TDocumentMainInformationFrame.SetViewModel(
  ViewModel: TDocumentMainInformationFormViewModel
);
begin
  
  FillUIElementsFromViewModel(ViewModel);

  FreeAndNil(FInitialViewModel);

  FInitialViewModel := ViewModel.Clone;

  FViewModel := ViewModel;

  FViewModel.OnPropertyChangedEventHandler := OnPropertyChangedEventHandler;

end;

procedure TDocumentMainInformationFrame.UpdateValidationPropsOfDocumentNumberEdits;
var
    TrimmedDocumentNumberPrefix: String;
    TrimmedDocumentNumberMainValue: String;
begin

  TrimmedDocumentNumberPrefix :=
    Trim(DocumentNumberPrefixEdit.Text);

  TrimmedDocumentNumberMainValue :=
    Trim(DocumentNumberMainValueEdit.Text);

  if (TrimmedDocumentNumberPrefix = '') and
     (TrimmedDocumentNumberMainValue = '')
  then begin

    DocumentNumberPrefixEdit.RegularExpression := '.*';
    DocumentNumberMainValueEdit.RegularExpression := '.*';

  end

  else if TrimmedDocumentNumberPrefix <> '' then begin

    DocumentNumberMainValueEdit.RegularExpression :=
      DOCUMENT_NUMBER_MAIN_VALUE_REG_EXPR;

    DocumentNumberMainValueEdit.InvalidHint :=
      DOCUMENT_NUMBER_MAIN_VALUE_INVALID_HINT;

  end

  else if Assigned(ViewModel) then begin

    DocumentNumberPrefixEdit.RegularExpression := ViewModel.NumberPrefixPattern;

  end;

  DocumentNumberPrefixEdit.UpdateValidationProperties;
  DocumentNumberMainValueEdit.UpdateValidationProperties;

end;

function TDocumentMainInformationFrame.ValidateInput: Boolean;

var IsDocumentNameValid, IsDocumentContentValid: Boolean;
    TrimmedDocumentNumberPrefix: String;
    TrimmedDocumentNumberMainValue: String;
    IsDocumentNumberMainValueValid,
    IsDocumentNumberPrefixValid: Boolean;

    DocumentNumberInvalidHint: String;
begin

  TrimmedDocumentNumberPrefix :=
    Trim(DocumentNumberPrefixEdit.Text);

  TrimmedDocumentNumberMainValue :=
    Trim(DocumentNumberMainValueEdit.Text);

  if (TrimmedDocumentNumberPrefix = '') and
     (TrimmedDocumentNumberMainValue = '')
  then begin

    DocumentNumberPrefixEdit.RegularExpression := '.*';
    DocumentNumberMainValueEdit.RegularExpression := '.*';

  end

  else if TrimmedDocumentNumberPrefix <> '' then begin

    DocumentNumberMainValueEdit.RegularExpression :=
      DOCUMENT_NUMBER_MAIN_VALUE_REG_EXPR;

    DocumentNumberMainValueEdit.InvalidHint :=
      DOCUMENT_NUMBER_MAIN_VALUE_INVALID_HINT;

  end

  else begin

    DocumentNumberPrefixEdit.RegularExpression := ViewModel.NumberPrefixPattern;

  end;

  IsDocumentNumberPrefixValid := DocumentNumberPrefixEdit.IsValid;
  IsDocumentNumberMainValueValid := DocumentNumberMainValueEdit.IsValid;
  IsDocumentNameValid := DocumentNameEdit.IsValid;
  IsDocumentContentValid := DocumentContentMemo.IsValid;

  Result :=
    IsDocumentNameValid
    and IsDocumentContentValid
    and IsDocumentNumberMainValueValid
    and IsDocumentNumberPrefixValid;

end;

end.
