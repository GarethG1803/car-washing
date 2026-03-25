import { Entity, Column, OneToMany } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';
import { Vehicle } from '../../vehicles/entities/vehicle.entity';
import { Booking } from '../../bookings/entities/booking.entity';
import { Review } from '../../reviews/entities/review.entity';
import { Payment } from '../../payments/entities/payment.entity';

export enum UserRole {
  CUSTOMER = 'customer',
  WASHER = 'washer',
  ADMIN = 'admin',
}

@Entity('users')
export class User extends BaseEntity {
  @Column()
  name: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true })
  phone: string;

  @Column()
  password: string;

  @Column({ type: 'text', default: UserRole.CUSTOMER })
  role: UserRole;

  @Column({ nullable: true })
  avatarUrl: string;

  @Column({ default: true })
  isActive: boolean;

  // Washer-specific fields
  @Column({ type: 'float', default: 0 })
  rating: number;

  @Column({ default: 0 })
  totalJobs: number;

  @Column({ type: 'float', default: 0 })
  totalEarnings: number;

  @Column({ nullable: true })
  bio: string;

  @Column({ type: 'simple-array', nullable: true })
  specialties: string[];

  // Customer loyalty
  @Column({ default: 0 })
  loyaltyPoints: number;

  @Column({ default: 'bronze' })
  loyaltyTier: string;

  @Column({ nullable: true })
  referralCode: string;

  @OneToMany(() => Vehicle, vehicle => vehicle.owner)
  vehicles: Vehicle[];

  @OneToMany(() => Booking, booking => booking.customer)
  bookings: Booking[];

  @OneToMany(() => Booking, booking => booking.washer)
  washerBookings: Booking[];

  @OneToMany(() => Review, review => review.customer)
  reviews: Review[];

  @OneToMany(() => Payment, payment => payment.user)
  payments: Payment[];
}
