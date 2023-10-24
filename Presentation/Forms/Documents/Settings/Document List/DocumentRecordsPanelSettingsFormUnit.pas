unit DocumentRecordsPanelSettingsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogFormUnit, StdCtrls, DeletableOnCloseFormUnit, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, cxButtons, dxSkinsCore,
  dxSkinsDefaultPainters;

type

  TOnDocumentRecordsPanelSettingsApplyingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;
    
  TDocumentRecordsPanelSettingsForm = class(TDeletableOnCloseForm)
    RecordGroupingByColumnsOptionCheckBox: TCheckBox;
    ApplySettingsButton: TcxButton;
    CloseButton: TcxButton;
    procedure ApplySettingsButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);

  private
    { Private declarations }

    FEnableRecordGroupingByColumnsOption: Boolean;
    
    FOnSettingsApplyingRequestedEventHandler:
      TOnDocumentRecordsPanelSettingsApplyingRequestedEventHandler;

    procedure Initialize;
    procedure SetColorToControls;
    
    function GetEnableDocumentRecordGroupingByColumnsOption: Boolean;
    procedure SetEnableDocumentRecordGroupingByColumnsOption(
      const Value: Boolean
    );

    procedure CloseWithResultIfModal(const Result: Cardinal);
    
    procedure RaiseOnSettingsApplyingRequestedEventHandler;

    procedure SaveUIControlSettings;
    procedure RestoreUIControlSettings;

    procedure FetchUIControlData;

  public
    { Public declarations }

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    property EnableDocumentRecordGroupingByColumnsOption: Boolean
    read GetEnableDocumentRecordGroupingByColumnsOption
    write SetEnableDocumentRecordGroupingByColumnsOption;

    property OnSettingsApplyingRequestedEventHandler:
      TOnDocumentRecordsPanelSettingsApplyingRequestedEventHandler
    read FOnSettingsApplyingRequestedEventHandler
    write FOnSettingsApplyingRequestedEventHandler;
    
  end;

var
  DocumentRecordsPanelSettingsForm: TDocumentRecordsPanelSettingsForm;

implementation

uses

  CommonControlStyles,
  IObjectPropertiesStorageUnit,
  ApplicationPropertiesStorageRegistry;

{$R *.dfm}

{ TDocumentRecordsSettingsForm }

procedure TDocumentRecordsPanelSettingsForm.ApplySettingsButtonClick(
  Sender: TObject);
begin

  FetchUIControlData;
  RaiseOnSettingsApplyingRequestedEventHandler;

  if fsModal in FFormState then
    CloseWithResultIfModal(mrOk);
  
end;

procedure TDocumentRecordsPanelSettingsForm.CloseWithResultIfModal(const Result: Cardinal);
begin

  if fsModal in FFormState then begin

    ModalResult := Result;
    CloseModal;

  end

  else Close;
  
end;

constructor TDocumentRecordsPanelSettingsForm.Create(AOwner: TComponent);
begin

  inherited;

  Initialize;
  
end;

destructor TDocumentRecordsPanelSettingsForm.Destroy;
begin

  SaveUIControlSettings;
  inherited;

end;

procedure TDocumentRecordsPanelSettingsForm.FetchUIControlData;
begin

  FEnableRecordGroupingByColumnsOption :=
    RecordGroupingByColumnsOptionCheckBox.Checked;
    
end;

procedure TDocumentRecordsPanelSettingsForm.CloseButtonClick(Sender: TObject);
begin

  CloseWithResultIfModal(mrCancel);

end;

function TDocumentRecordsPanelSettingsForm.GetEnableDocumentRecordGroupingByColumnsOption: Boolean;
begin

  Result := FEnableRecordGroupingByColumnsOption;
  
end;

procedure TDocumentRecordsPanelSettingsForm.Initialize;
begin

  RestoreUIControlSettings;
  SetColorToControls;
  
end;

procedure TDocumentRecordsPanelSettingsForm.RaiseOnSettingsApplyingRequestedEventHandler;
begin

  if Assigned(FOnSettingsApplyingRequestedEventHandler) then
    FOnSettingsApplyingRequestedEventHandler(Self);
    
end;

procedure TDocumentRecordsPanelSettingsForm.RestoreUIControlSettings;
var PropertiesStorage: IObjectPropertiesStorage;
begin

  PropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.
        GetPropertiesStorageForObjectClass(ClassType);

  PropertiesStorage.RestorePropertiesForObject(Self);

end;

procedure TDocumentRecordsPanelSettingsForm.SaveUIControlSettings;
var PropertiesStorage: IObjectPropertiesStorage;
begin

  PropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.
        GetPropertiesStorageForObjectClass(ClassType);

  PropertiesStorage.SaveObjectProperties(Self);
  
end;

procedure TDocumentRecordsPanelSettingsForm.SetColorToControls;
begin

  Color := TDocumentFlowCommonControlStyles.GetFormBackgroundColor;

  ApplySettingsButton.Colors.Default :=
    TDocumentFlowCommonControlStyles.GetButtonBackgroundColor;

  ApplySettingsButton.Font.Style :=
    TDocumentFlowCommonControlStyles.GetButtonCaptionFontStyle;

  CloseButton.Colors.Default :=
    TDocumentFlowCommonControlStyles.GetButtonBackgroundColor;

  CloseButton.Font.Style :=
    TDocumentFlowCommonControlStyles.GetButtonCaptionFontStyle;
    
end;

procedure TDocumentRecordsPanelSettingsForm.SetEnableDocumentRecordGroupingByColumnsOption(
  const Value: Boolean);
begin

  RecordGroupingByColumnsOptionCheckBox.Checked := Value;
  FEnableRecordGroupingByColumnsOption := Value;

end;

end.
