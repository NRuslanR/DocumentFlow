inherited PersonnelOrderCardFrame: TPersonnelOrderCardFrame
  Height = 424
  ExplicitHeight = 424
  inherited ScrollBox: TScrollBox
    Height = 424
    ExplicitHeight = 424
    inherited DocumentInfoPanel: TPanel
      Height = 424
      ExplicitHeight = 424
      inherited DocumentCardPageControl: TPageControl
        Height = 386
        ActivePage = DocumentChargesPage
        ExplicitHeight = 386
        inherited DocumentMainInfoAndReceiversPage: TTabSheet
          ExplicitHeight = 358
          inherited SplitterBetweenMainInfoAndReceiversAreas: TSplitter
            Top = 167
            Visible = False
          end
          inherited DocumentMainInfoArea: TPanel
            Height = 167
            ExplicitHeight = 167
            inherited DocumentMainInfoLabel: TLabel
              Visible = False
            end
            inherited DocumentMainInfoFormArea: TPanel
              Height = 154
              ExplicitHeight = 156
            end
          end
          inherited DocumentChargesInfoArea: TPanel
            Top = 171
            Height = 187
            Visible = False
            ExplicitTop = 200
            ExplicitHeight = 158
            inherited DocumentChargesFormArea: TPanel
              Height = 174
              ExplicitHeight = 0
            end
          end
        end
        inherited DocumentRelationsAndFilesPage: TTabSheet
          ExplicitHeight = 358
          inherited RelatedDocumentsAndFilesPanel: TPanel
            Height = 358
            ExplicitHeight = 358
            inherited SplitterBetweenRelationsAndFilesAreas: TSplitter
              Height = 358
              ExplicitHeight = 410
            end
            inherited DocumentRelationsInfoArea: TPanel
              Height = 358
              ExplicitHeight = 358
              inherited DocumentRelationsFormArea: TPanel
                Height = 345
                ExplicitHeight = 345
              end
            end
            inherited DocumentFilesInfoArea: TPanel
              Height = 358
              ExplicitHeight = 358
              inherited DocumentFilesFormArea: TPanel
                Height = 345
                ExplicitHeight = 345
              end
            end
          end
        end
        inherited DocumentApprovingPage: TTabSheet
          ExplicitHeight = 358
          inherited DocumentApprovingsPagePanel: TPanel
            Height = 358
            ExplicitHeight = 358
          end
        end
        inherited DocumentPreviewPage: TTabSheet
          ExplicitHeight = 358
          inherited DocumentFilesViewFormPanel: TPanel
            Height = 358
            ExplicitHeight = 358
          end
        end
        inherited DocumentMainInfoPage: TTabSheet
          ExplicitHeight = 358
        end
        inherited DocumentChargesPage: TTabSheet
          ExplicitHeight = 358
        end
      end
      inherited FooterButtonPanel: TPanel
        Top = 386
        ExplicitTop = 386
      end
    end
  end
end
