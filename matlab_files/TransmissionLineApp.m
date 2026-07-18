function TransmissionLineApp
   fig = uifigure('Name','Transmission Line Calculator','Position',[200 100 1400 720]);
   pnl1 = uipanel(fig,'Title','Inputs','FontWeight','bold','Position',[15 15 520 690]);
   y = 630; step = 35;
   freq = createNumField(pnl1,50,'Frequency (Hz):',y); y=y-step;
   len   = createNumField(pnl1,100,'Line Length (km):',y); y=y-step;
   Rpk   = createNumField(pnl1,0.13,'Resistance R (ohm/km):',y); y=y-step;
   Lpk   = createNumField(pnl1,0.00129,'Inductance L (H/km):',y); y=y-step;
   Cpk   = createNumField(pnl1,9e-9,'Capacitance C (F/km):',y); y=y-step;
   Gpk   = createNumField(pnl1,0,'Conductance G (S/km):',y); y=y-step;
   Vr    = createNumField(pnl1,1.1e5,'Receiving Voltage (V):',y); y=y-step;
   Pload = createNumField(pnl1,5e6,'Load Power (W):',y); y=y-step;
   pf    = createNumField(pnl1,0.8,'Power factor (+lag / -lead):',y); y=y-step;
   bg = uibuttongroup(pnl1,'Title','Medium Line Model','FontWeight','bold','Position',[20 y-80 220 75]);
   r_pi = uiradiobutton(bg,'Text','Nominal \pi','Position',[15 35 120 20],'Value',true);
   r_T  = uiradiobutton(bg,'Text','Nominal T','Position',[15 10 120 20]);
   runBtn = uibutton(pnl1,'push','Text','Run Calculation',...
            'Position',[260 y-75 230 65],'FontWeight','bold','FontSize',13,...
            'ButtonPushedFcn', @(~,~) runCalc());
   lossPanelTop = y - 95;
   lossPanel = uipanel(pnl1,'Title','Losses (select to enable params)',...
                       'Position',[15 20 490 lossPanelTop-20],'FontSize',10);
   yLoss = lossPanelTop - 55;
   cb_cu   = uicheckbox(lossPanel,'Text','Copper Loss (I²R)','Position',[10 yLoss 180 20],'Value',true); yLoss=yLoss-30;
   cb_die  = uicheckbox(lossPanel,'Text','Dielectric Loss (tan δ)','Position',[10 yLoss 180 20],'Value',false); yLoss=yLoss-30;
   cb_cor  = uicheckbox(lossPanel,'Text','Corona Loss','Position',[10 yLoss 180 20],'Value',false); yLoss=yLoss-30;
   cb_skin = uicheckbox(lossPanel,'Text','Skin/Proximity Loss','Position',[10 yLoss 180 20],'Value',false); yLoss=yLoss-30;
   cb_thd  = uicheckbox(lossPanel,'Text','Harmonic Loss (THD)','Position',[10 yLoss 180 20],'Value',false); yLoss=yLoss-30;
   cb_eddy = uicheckbox(lossPanel,'Text','Eddy/Hardware Loss','Position',[10 yLoss 180 20],'Value',false);
   yCol2 = lossPanelTop - 55;
  
   lbl_tand = uilabel(lossPanel,'Text','tan δ','Position',[205 yCol2 40 20],'Visible','off','FontSize',9);
   ed_tand = uieditfield(lossPanel,'numeric','Position',[250 yCol2 60 20],'Visible','off','Value',0.01,'FontSize',9);
   sld_tand = uislider(lossPanel,'Limits',[1e-4 0.05],'Position',[320 yCol2+8 150 3],'Visible','off','Value',0.01,'FontSize',7);
   sld_tand.ValueChangedFcn = @(~,~) set(ed_tand,'Value',sld_tand.Value);
   ed_tand.ValueChangedFcn = @(~,~) set(sld_tand,'Value',ed_tand.Value);
   yCol2 = yCol2 - 30;
   lbl_m0 = uilabel(lossPanel,'Text','m₀','Position',[205 yCol2 40 20],'Visible','off','FontSize',9);
   ed_m0 = uieditfield(lossPanel,'numeric','Position',[245 yCol2 40 15],'Visible','off','Value',0.95,'FontSize',9);
  
   lbl_press = uilabel(lossPanel,'Text','P (torr)','Position',[330 yCol2 40 15],'Visible','off','FontSize',9);
   ed_press = uieditfield(lossPanel,'numeric','Position',[385 yCol2 40 15],'Visible','off','Value',760,'FontSize',9);
   yCol2 = yCol2 - 28;
  
   lbl_temp = uilabel(lossPanel,'Text','T (°C)','Position',[205 yCol2 40 20],'Visible','off','FontSize',9);
   ed_temp = uieditfield(lossPanel,'numeric','Position',[245 yCol2 40 15],'Visible','off','Value',25,'FontSize',9);
  
   lbl_radius = uilabel(lossPanel,'Text','r (cm)','Position',[330 yCol2 45 20],'Visible','off','FontSize',9);
   ed_radius = uieditfield(lossPanel,'numeric','Position',[375 yCol2 70 20],'Visible','off','Value',1,'FontSize',9);
   yCol2 = yCol2 - 28;
  
   lbl_spacing = uilabel(lossPanel,'Text','D (cm)','Position',[205 yCol2 45 20],'Visible','off','FontSize',9);
   ed_spacing = uieditfield(lossPanel,'numeric','Position',[250 yCol2 70 20],'Visible','off','Value',30,'FontSize',9);
   yCol2 = yCol2 - 30;
   lbl_thd = uilabel(lossPanel,'Text','THD (%)','Position',[205 yCol2 55 20],'Visible','off','FontSize',9);
   ed_thd = uieditfield(lossPanel,'numeric','Position',[265 yCol2 60 20],'Visible','off','Value',5,'FontSize',9);
   sld_thd = uislider(lossPanel,'Limits',[0 50],'Position',[335 yCol2+8 135 3],'Visible','off','Value',5,'FontSize',7);
   sld_thd.ValueChangedFcn = @(~,~) set(ed_thd,'Value',sld_thd.Value);
   ed_thd.ValueChangedFcn = @(~,~) set(sld_thd,'Value',ed_thd.Value);
   cb_die.ValueChangedFcn = @(src,event) toggleDieUI(src.Value);
   cb_cor.ValueChangedFcn = @(src,event) toggleCoronaUI(src.Value);
   cb_thd.ValueChangedFcn = @(src,event) toggleTHDUI(src.Value);
   function toggleDieUI(val)
       vis = 'off'; if val, vis = 'on'; end
       lbl_tand.Visible = vis; sld_tand.Visible = vis; ed_tand.Visible = vis;
   end
   function toggleCoronaUI(val)
       vis = 'off'; if val, vis = 'on'; end
       lbl_m0.Visible=vis; ed_m0.Visible=vis;
       lbl_press.Visible=vis; ed_press.Visible=vis;
       lbl_temp.Visible=vis; ed_temp.Visible=vis;
       lbl_radius.Visible=vis; ed_radius.Visible=vis;
       lbl_spacing.Visible=vis; ed_spacing.Visible=vis;
   end
   function toggleTHDUI(val)
       vis = 'off'; if val, vis = 'on'; end
       lbl_thd.Visible=vis; sld_thd.Visible=vis; ed_thd.Visible=vis;
   end
   pnl2 = uipanel(fig,'Title','Results','FontWeight','bold','Position',[550 15 820 690]);
   ax1 = uiaxes(pnl2,'Position',[40 290 350 380]);
   title(ax1,'Receiving End Voltage vs Line Length');
   xlabel(ax1,'Length (km)'); ylabel(ax1,'V_{Receiving} (kV)'); grid(ax1,'on');
  
   ax2 = uiaxes(pnl2,'Position',[410 290 350 380]);
   title(ax2,'Voltage Regulation vs Length');
   xlabel(ax2,'Length (km)'); ylabel(ax2,'Reg (%)'); grid(ax2,'on');
  
   ax3 = uiaxes(pnl2,'Position',[40 0 350 270]);
   title(ax3,'Efficiency vs Length');
   xlabel(ax3,'Length (km)'); ylabel(ax3,'Eff (%)'); grid(ax3,'on');
  
   axPie = uiaxes(pnl2,'Position',[410 150 350 120]);
   title(axPie,'Loss Distribution','FontSize',10); axis(axPie,'equal');
  
   legendPanel = uipanel(pnl2,'Position',[410 120 350 40],'BorderType','none');
   legendText = uilabel(legendPanel,'Position',[5 0 340 40],'Text','','FontSize',8,...
                       'HorizontalAlignment','left','VerticalAlignment','top');
   summaryArea = uitextarea(pnl2,'Position',[410 20 350 90],'Editable','off','FontSize',12);
   appData = struct();
   function runCalc()
       f = freq.Value;
       length_km = len.Value;
       r_per_km = Rpk.Value;
       l_per_km = Lpk.Value;
       c_per_km = Cpk.Value;
       g_per_km = Gpk.Value;
       Vr_rms = Vr.Value;
       P_load = Pload.Value;
       pf_in = pf.Value;
       if r_pi.Value
           model_option_choice = 1;
       else
           model_option_choice = 2;
       end
       omega = 2*pi*f;
       Rtot = r_per_km * length_km;
       Ltot = l_per_km * length_km;
       Z = Rtot + 1i*omega*Ltot;
       if abs(c_per_km) >= 1e-6
           B_per_km = c_per_km;
           C_per_km = B_per_km / omega;
           noteStr = sprintf('Input interpreted as B = %.4e S/km => C = %.4e F/km', B_per_km, C_per_km);
       else
           C_per_km = c_per_km;
           B_per_km = omega * C_per_km;
           noteStr = sprintf('Input interpreted as C = %.4e F/km => B = %.4e S/km', C_per_km, B_per_km);
       end
       if length_km < 80
           line_type = 'Short Transmission Line';
           model_option = 0;
       elseif length_km >= 80 && length_km <= 250
           line_type = 'Medium Transmission Line';
           model_option = model_option_choice;
       else
           line_type = 'Long Transmission Line';
           model_option = 3;
       end
       Gtot = g_per_km * length_km;
       Y = Gtot + 1i*(B_per_km * length_km);
       if model_option == 0
           A = 1; D = 1; B = Z; C = 0;
       elseif model_option == 1
           A = 1 + (Y .* Z) / 2;
           B = Z;
           C = Y .* (1 + (Y .* Z) / 4);
           D = A;
       elseif model_option == 2
           A = 1 + (Y .* Z) / 2;
           B = Z .* (1 + (Y .* Z) / 4);
           C = Y;
           D = A;
       else
           Zp = r_per_km + 1i*omega*l_per_km;
           Yp = g_per_km + 1i*omega*C_per_km;
           gamma = sqrt(Zp .* Yp);
           Zc = sqrt(Zp ./ Yp);
           A = cosh(gamma * length_km);
           B = Zc .* sinh(gamma * length_km);
           C = sinh(gamma * length_km) ./ Zc;
           D = A;
       end
       isThreePhase = true;
       if isThreePhase
           V_R = Vr_rms / sqrt(3);
           P_phase = P_load / 3;
       else
           V_R = Vr_rms;
           P_phase = P_load;
       end
       if abs(pf_in) > 1 || abs(pf_in) == 0
           uialert(fig,'Power factor must be between -1 and +1 and nonzero.','PF error'); return;
       end
       pf_mag = abs(pf_in);
       phi = acos(pf_mag);
       Q_phase = P_phase * tan(phi) * sign(pf_in);
       S_phase = P_phase + 1i * Q_phase;
       I_R = conj(S_phase) ./ conj(V_R);
       V_S = A .* V_R + B .* I_R;
       I_S = C .* V_R + D .* I_R;
       S_S = V_S .* conj(I_S);
       S_R = V_R .* conj(I_R);
       P_S = real(S_S); P_R = real(S_R);
       losses_ABCD = P_S - P_R;
       if P_S == 0
           efficiency_ABCD = 0;
       else
           efficiency_ABCD = (P_R / P_S) * 100;
       end
       V_R_noload = V_S ./ A;
       regulation = ((abs(V_R_noload) - abs(V_R)) ./ abs(V_R)) * 100;
       L_vec = 1:5:400;
       Vr_f = zeros(size(L_vec));
       Reg_f = zeros(size(L_vec));
       Eff_f = zeros(size(L_vec));
       Vs_base = abs(V_R)*sqrt(3);
       for k=1:length(L_vec)
           Ltemp = L_vec(k);
           Rtemp = r_per_km * Ltemp;
           Ltemp2 = l_per_km * Ltemp;
           Zt = Rtemp + 1i*omega*Ltemp2;
           Yt = g_per_km * Ltemp + 1i*(B_per_km * Ltemp);
           At = 1 + (Yt*Zt)/2;
           Bt = Zt;
           Ct = Yt*(1+(Yt*Zt)/4);
           Dt = At;
           VRt = Vs_base/(sqrt(3)*abs(At));
           Vr_f(k) = VRt*sqrt(3);
           I_Rt = abs(conj(S_phase)/conj(VRt));
           V_St = At*VRt + Bt*I_Rt;
           I_St = Ct*VRt + Dt*I_Rt;
           StS = V_St*conj(I_St);
           StR = VRt*conj(I_Rt);
           Reg_f(k) = ((abs(V_St/At)-VRt)/VRt)*100;
           Eff_f(k) = real(StR)/real(StS)*100;
       end
       loss_labels = {}; loss_values = [];
       if cb_cu.Value
           P_Cu = 3 * (abs(I_R)^2) * (r_per_km * length_km);
           loss_labels{end+1} = 'Copper';
           loss_values(end+1) = P_Cu;
       else
           P_Cu = 0;
       end
       if cb_die.Value
           tan_delta = ed_tand.Value;
           P_die = 3 * omega * C_per_km * (V_R^2) * tan_delta * length_km;
           loss_labels{end+1} = 'Dielectric';
           loss_values(end+1) = P_die;
       else
           P_die = 0;
       end
       if cb_cor.Value
           Vp = V_R/1000;
           r_cond = ed_radius.Value;
           D = ed_spacing.Value;
           m0_val = ed_m0.Value;
           Tval = ed_temp.Value;
           Pval = ed_press.Value;
           delta = 0.386 * Pval / (273 + Tval);
           if D <= r_cond
               Uc = NaN;
           else
               Uc = 21.1 * m0_val * delta * r_cond * log(D/r_cond);
           end
           F = 1.0;
           if Uc==0 || isnan(Uc)
               Pc = 0;
           else
               Pc = 2.094 * f * ((Vp./Uc).^2) * F * 1e-5 * 1000 * length_km * 3;
           end
           loss_labels{end+1} = 'Corona';
           loss_values(end+1) = Pc;
       else
           Pc = 0;
       end
       if cb_skin.Value
           wcrit = 314;
           Rac = r_per_km * (1 + (1/10)*(omega/wcrit)^2);
           P_skin = 3 * abs(I_R)^2 * (Rac - r_per_km) * length_km;
           loss_labels{end+1} = 'Skin/Prox';
           loss_values(end+1) = P_skin;
       else
           P_skin = 0;
       end
       if cb_thd.Value
           THD = ed_thd.Value/100;
           P_harm = P_Cu * (THD^2);
           loss_labels{end+1} = 'Harmonic';
           loss_values(end+1) = P_harm;
       else
           P_harm = 0;
       end
       if cb_eddy.Value
           alpha = 8; F = 0.2; T2 = 90; T1 = 25;
           P_eddy = 3 * alpha * F * (T2 - T1);
           loss_labels{end+1} = 'Eddy/Rad';
           loss_values(end+1) = P_eddy;
       else
           P_eddy = 0;
       end
       total_calc_loss = sum(loss_values);
       P_total_in = P_S;
       P_total_out = P_total_in - total_calc_loss;
       if P_total_in==0
           efficiency_incl = 0;
       else
           efficiency_incl = (P_total_out / P_total_in) * 100;
       end
       sumLines = {
           sprintf('Line classification: %s', line_type);
           sprintf('%s', noteStr);
           '';
           sprintf('A = %.6f %+.6fj', real(A), imag(A));
           sprintf('B = %.6f %+.6fj', real(B), imag(B));
           sprintf('C = %.6e %+.6ej', real(C), imag(C));
           sprintf('D = %.6f %+.6fj', real(D), imag(D));
           '';
           sprintf('Receiving end current magnitude (phase): %.4f A', abs(I_R));
           sprintf('Sending end current magnitude   (phase): %.4f A', abs(I_S));
           sprintf('Sending end phase voltage       : %.2f V', abs(V_S));
           sprintf('Receiving end phase voltage     : %.2f V', abs(V_R));
           ''};
       if isThreePhase
           sumLines{end+1} = sprintf('Sending end line (L-L) voltage  : %.2f V', abs(V_S)*sqrt(3));
           sumLines{end+1} = sprintf('Receiving end line (L-L) voltage: %.2f V', abs(V_R)*sqrt(3));
       end
       sumLines{end+1} = sprintf('Voltage Regulation              : %.2f %%', regulation);
       sumLines{end+1} = sprintf('Efficiency (ABCD)               : %.2f %%', efficiency_ABCD);
       sumLines{end+1} = sprintf('Total losses (ABCD)             : %.4f W', losses_ABCD);
       sumLines{end+1} = '';
       sumLines{end+1} = sprintf('Total Calculated Loss (selected): %.3f W', total_calc_loss);
       sumLines{end+1} = sprintf('Total Power Out (including selections): %.3f W', P_total_out);
       sumLines{end+1} = sprintf('Efficiency including selected losses = %.2f %%', efficiency_incl);
       summaryArea.Value = sumLines;
       plot(ax1,L_vec,Vr_f/1e3,'LineWidth',1.6);
       xlabel(ax1,'Line Length (km)'); ylabel(ax1,'V_{Receiving} (kV)'); grid(ax1,'on');
      
       plot(ax2,L_vec,Reg_f,'LineWidth',1.6);
       xlabel(ax2,'Line Length (km)'); ylabel(ax2,'Voltage Regulation (%)'); grid(ax2,'on');
      
       plot(ax3,L_vec,Eff_f,'LineWidth',1.6);
       xlabel(ax3,'Line Length (km)'); ylabel(ax3,'Efficiency (%)'); grid(ax3,'on');
       cla(axPie);
       if isempty(loss_values) || all(loss_values==0)
           text(axPie,0.5,0.5,'No losses selected or all zero','HorizontalAlignment','center','FontSize',9);
           legendText.Text = '';
       else
           pie(axPie,loss_values,repmat({''},size(loss_labels)));
           legendStr = '';
           for i=1:length(loss_labels)
               if i>1, legendStr = [legendStr, ' | ']; end
               legendStr = [legendStr, sprintf('%s: %.1f W', loss_labels{i}, loss_values(i))];
           end
           legendText.Text = legendStr;
       end
       appData.inputs = struct('f',f,'length_km',length_km,'r_per_km',r_per_km,'l_per_km',l_per_km,'c_per_km',c_per_km,'g_per_km',g_per_km,'Vr_rms',Vr_rms,'P_load',P_load,'pf',pf_in);
       appData.results = struct('A',A,'B',B,'C',C,'D',D,'I_R',I_R,'I_S',I_S,'V_R',V_R,'V_S',V_S,'regulation',regulation,'efficiency_ABCD',efficiency_ABCD,'losses_ABCD',losses_ABCD,'loss_labels',loss_labels,'loss_values',loss_values);
   end
   function fld = createNumField(parent,initVal,labelText,posY)
       uilabel(parent,'Position',[20 posY 180 22],'Text',labelText,'FontSize',11);
       fld = uieditfield(parent,'numeric','Position',[220 posY 120 22],'Value',initVal);
   end
end

