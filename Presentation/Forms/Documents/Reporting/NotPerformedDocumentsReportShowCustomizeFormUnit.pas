unit NotPerformedDocumentsReportShowCustomizeFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons, ComCtrls, DialogFormUnit, DepartmentViewModel, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TNotPerformedDocumentsReportShowCustomizeForm = class(TForm)
    Label1: TLabel;
    PeriodStartPicker: TDateTimePicker;
    Label2: TLabel;
    PeriodEndPicker: TDateTimePicker;
    FormReportButton: TcxButton;
    CloseButton: TcxButton;
    DepartmentLabel: TLabel;
    DepartmentsComboBox: TComboBox;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormReportButtonClick(Sender: TObject);
  private
    { Private declarations }

    FDepartmentsViewModel: TDepartmentsViewModel;

    function ValidateInputPeriod: Boolean;
    function ValidateSelectedDepartmentItem: Boolean;
    function ValidateInput: Boolean;

    function GetPeriodEnd: TDateTime;
    function GetPeriodStart: TDateTime;

    procedure CustomizeStyle;
    procedure CustomizeButtonStyle(Button: TcxButton);
    procedure CustomizeReportPeriod;
    procedure CustomizeInitialState;

    procedure SetDepartmentsViewModel(const Value: TDepartmentsViewModel);
    procedure FillDepartmentsListControl;
    function GetSelectedDepartmentViewModel: TDepartmentViewModel;
    
  public
    { Public declarations }

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

  published

    property PeriodStart: TDateTime read GetPeriodStart;
    property PeriodEnd: TDateTime read GetPeriodEnd;
    property SelectedDepartmentViewModel: TDepartmentViewModel
    read GetSelectedDepartmentViewModel;
    
    property DepartmentsViewModel: TDepartmentsViewModel
    read FDepartmentsViewModel write SetDepartmentsViewModel;
    
  end;

var
  NotPerformedDocumentsReportShowCustomizeForm: TNotPerformedDocumentsReportShowCustomizeForm;

implementation

uses

  DateUtils,
  VariantTypeUnit,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  CommonControlStyles;

{$R *.dfm}

procedure TNotPerformedDocumentsReportShowCustomizeForm.CloseButtonClick(
  Sender: TObject);
begin

  if fsModal in FFormState then begin

    ModalResult := mrCancel;
    CloseModal;

  end

  else Close;

end;

constructor TNotPerformedDocumentsReportShowCustomizeForm.Create(
  AOwner: TComponent);
begin

  inherited;

  CustomizeInitialState;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.CustomizeButtonStyle(
  Button: TcxButton);
begin

  Button.Colors.Default :=
    TDocumentFlowCommonControlStyles.GetButtonBackgroundColor;

  Button.Font.Style :=
    TDocumentFlowCommonControlStyles.GetButtonCaptionFontStyle;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.CustomizeInitialState;
begin

  CustomizeReportPeriod;
  CustomizeStyle;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.CustomizeReportPeriod;
var CurrentDate: TDateTime;
    StartOfCurrentDateMonth: TDateTime;
begin

  CurrentDate := Now;
  StartOfCurrentDateMonth := StartOfTheMonth(CurrentDate);

  PeriodStartPicker.DateTime := StartOfCurrentDateMonth;
  PeriodEndPicker.DateTime := CurrentDate;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.CustomizeStyle;
begin

  Color := TDocumentFlowCommonControlStyles.GetFormBackgroundColor;

  CustomizeButtonStyle(FormReportButton);
  CustomizeButtonStyle(CloseButton);

end;

destructor TNotPerformedDocumentsReportShowCustomizeForm.Destroy;
begin

  FreeAndNil(FDepartmentsViewModel);
  inherited;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.FillDepartmentsListControl;
var DepartmentViewModel: TDepartmentViewModel;
begin

  for DepartmentViewModel in FDepartmentsViewModel do begin

    DepartmentsComboBox.AddItem(
      DepartmentViewModel.ShortName,
      DepartmentViewModel
    );

  end;

  DepartmentsComboBox.ItemIndex := 0;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.FormReportButtonClick(
  Sender: TObject);
begin

  if not ValidateInput then Exit;
  
  if fsModal in FFormState then begin

    ModalResult := mrOk;
    CloseModal;

  end

  else Close;

end;

function TNotPerformedDocumentsReportShowCustomizeForm.GetPeriodEnd: TDateTime;
begin

  Result := PeriodEndPicker.DateTime;

end;

function TNotPerformedDocumentsReportShowCustomizeForm.GetPeriodStart: TDateTime;
begin

  Result := PeriodStartPicker.DateTime;
  
end;

function TNotPerformedDocumentsReportShowCustomizeForm.
  GetSelectedDepartmentViewModel: TDepartmentViewModel;
var ItemObject: TObject;
begin

  ItemObject :=
    DepartmentsComboBox.Items.Objects[DepartmentsComboBox.ItemIndex];

  if not Assigned(ItemObject) then
    Result := nil

  else Result := ItemObject as TDepartmentViewModel;

end;

procedure TNotPerformedDocumentsReportShowCustomizeForm.
  SetDepartmentsViewModel(
    const Value: TDepartmentsViewModel
  );
begin

  FreeAndNil(FDepartmentsViewModel);
  
  FDepartmentsViewModel := Value;

  FillDepartmentsListControl;

end;

function TNotPerformedDocumentsReportShowCustomizeForm.ValidateInput: Boolean;
begin

  Result :=
    ValidateInputPeriod and
    ValidateSelectedDepartmentItem;
    
end;

function TNotPerformedDocumentsReportShowCustomizeForm.ValidateInputPeriod: Boolean;
begin

  if PeriodStartPicker.DateTime > PeriodEndPicker.DateTime then begin

    ShowErrorMessage(
      Self.Handle,
      'Íà÷àëüíàÿ äàòà ïåğèîäà ' +
      'äîëæíà ïğåäøåñòâîâàòü êîíå÷íîé äàòå ' +
      'èëè ñîâïàäàòü ñ íåé',
      'Îøèáêà'
    );

    Result := False;

  end

  else Result := True;

end;

function TNotPerformedDocumentsReportShowCustomizeForm.ValidateSelectedDepartmentItem: Boolean;
begin

  Result := DepartmentsComboBox.ItemIndex >= 0;
  
end;

end.
